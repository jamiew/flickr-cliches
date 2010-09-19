['rubygems','yaml','fileutils','flickr_fu','faster_csv','mechanize'].each{|lib| require lib }
load "utils.rb"
DATA_DIR = File.dirname(__FILE__)+"/data"

def load_from_config
  @flickr = Flickr.new(File.dirname(__FILE__)+'/config.yml')
  if File.exists?(File.dirname(__FILE__)+'/'+@flickr.token_cache)
    puts "Already authorized! Delete #{@flickr.token_cache} to reset"
  else
    puts "Authorizing Flickr... we'll now launch your web browser (on a Mac)"
    puts "Click 'Authorize Yo', then come back here & press enter to continue."
    auth_url = @flickr.auth.url(:read)
    `open '#{auth_url}'`
    gets
    @flickr.auth.cache_token
  end
  page = ENV['PAGE'] && ENV['PAGE'].to_i || 1
  per_page = ENV['PER_PAGE'] && ENV['PER_PAGE'].to_i || 10
  sort = 'interestingness-desc'
  @data_files = []
  run_tags(page,per_page,sort)
  run_geo(page,per_page,sort)
end

def run_geo(page, per_page, sort)
  bounding_boxes = YAML.load(File.open(File.dirname(__FILE__)+'/bounding_boxes.yml'))

  bounding_boxes.each do |hash|
      country = hash.keys[0]
      box = hash.values[0]
      safe_country = country.downcase.gsub(' ','_').gsub(',','')
      country_dir = "#{DATA_DIR}/geos/#{safe_country}"
      FileUtils.mkdir_p(country_dir)

      bbox = "#{box[0][1]},#{box[0][0]},#{box[1][1]},#{box[1][0]}"
      opts = {:page => page, :per_page => per_page, :media => 'photo', :sort => sort, :bbox => bbox}

      puts "\nSearching for interesting photos in #{country} => #{box.inspect} ..."
      collect_data(opts, "geos", safe_country)
  end
  save_data("geos")
end

def run_tags(page, per_page, sort)
  tags = YAML.load(File.open(File.dirname(__FILE__)+'/tags.yml'))
  tags.each do |hash|
      tag_parent = hash.keys.first.downcase.gsub(' ','_').gsub(',','')
      country_dir = "#{DATA_DIR}/tags/#{tag_parent}"
      FileUtils.mkdir_p(country_dir)
      opts = {:page => page, :per_page => per_page, :media => 'photo', :sort => sort, :tags => hash.values.first}
      puts "\nSearching for interesting photos in #{hash.keys.first} => #{hash.values.first.inspect} ..."
      collect_data(opts, "tags", tag_parent)
  end
  save_data("tags")
end

def collect_data(opts, dir, sub_dir)
  photos = @flickr.photos.search(opts)
  ts = []
  data_file = []
  photos.each do |photo|
    ts << Thread.new{
      photo_id = photo.url.split('/')[-1]
      location_info = photo.location && "#{photo.location && photo.location.latitude},#{photo.location && photo.location.longitude}] (#{photo.location.accuracy})" || 'nil'
      puts "Views: #{photo.views}  Location: #{location_info} \tDate: #{photo.taken_at.to_s}  URL: #{photo.photopage_url}"
      data_file << {"internal_category" => sub_dir, 
        "photo_id" => photo_id, 
        "photopage_url" => photo.photopage_url, 
        "owner" => photo.owner, 
        "owner_realname" => photo.owner_realname, 
        "taken_at" => photo.taken_at.strftime("%Y-%m-%d %H:%M:%S"), 
        "updated_at" => photo.updated_at.strftime("%Y-%m-%d %H:%M:%S"), 
        "lat" => photo.location && photo.location.latitude, 
        "lon" => photo.location && photo.location.longitude, 
        "views" => photo.views, 
        "tags" => sanitize_tags(photo.tags)}
      open_image(photo.photopage_url)
      download_image(dir+"/"+sub_dir,photo,photo_id)
    }
  end
  ts.collect{|t| t.join}
  STDERR.puts "Dumping raw CSV data..."
  file_loc = "#{DATA_DIR}/#{dir}/#{sub_dir}/data.csv"
  data_file << file_loc
  @data_files << data_file
end

def open_image(photopage_url)
  if ENV['OPEN']
    `open '#{photo.photopage_url}'`
  end  
end

def download_image(sub_dir,photo,photo_id)
  if ENV['DOWNLOAD']
    filename = "#{DATA_DIR}/#{sub_dir}/#{photo_id}"
    file = photo.url.scan(/\/\/.*\/(.*)/).to_s
    `wget #{photo.url}`
    `mv #{photo_id} #{filename}`
  end
end
  
def csv_dump(data,file_loc)
  FasterCSV.open(file_loc, "w") do |csv|
    headers = data.first.keys
    csv << headers
    data.each do |datum|
      csv << headers.collect{|header| datum[header] }
    end
  end
end


def save_data(sub_dir)
  @data_files.each do |data_file|
    file_loc = data_file.last
    puts "Saving data for #{file_loc}..."
    data_file = data_file[0..data_file.length-2]
    csv_dump(data_file,file_loc)
  end
  # Combine all CSVs into one mega CSV
  puts "\nCombining into one output CSV..."
  puts @data_files.inspect
  output = "#{DATA_DIR}/#{sub_dir}/combined.csv"
  header_done = false
  csv_dump(@data_files.collect{|f| f[0..f.length-2]}.flatten,output)
  puts "Done."
end
load_from_config