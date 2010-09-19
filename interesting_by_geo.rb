#!/usr/bin/env ruby

['rubygems','yaml','fileutils','flickr_fu','faster_csv','mechanize'].each{|lib| require lib }
load "utils.rb"

flickr = Flickr.new(File.dirname(__FILE__)+'/config.yml')
if File.exists?(File.dirname(__FILE__)+'/'+flickr.token_cache)
  puts "Already authorized! Delete #{flickr.token_cache} to reset"
else
  puts "Authorizing Flickr... we'll now launch your web browser (on a Mac)"
  puts "Click 'Authorize Yo', then come back here & press enter to continue."
  auth_url = flickr.auth.url(:read)
  `open '#{auth_url}'`
  gets
  flickr.auth.cache_token
end

page = ENV['PAGE'] && ENV['PAGE'].to_i || 1
per_page = ENV['PER_PAGE'] && ENV['PER_PAGE'].to_i || 10
sort = 'interestingness-desc'

data_dir = File.dirname(__FILE__)+"/data"
data_files = []
bounding_boxes = YAML.load(File.open(File.dirname(__FILE__)+'/bounding_boxes.yml'))

bounding_boxes.each do |hash|

  country = hash.keys[0]
  box = hash.values[0]
  safe_country = country.downcase.gsub(' ','_').gsub(',','')
  country_dir = "#{data_dir}/#{safe_country}"
  FileUtils.mkdir_p(country_dir)

  bbox = "#{box[0][1]},#{box[0][0]},#{box[1][1]},#{box[1][0]}"
  opts = {:page => page, :per_page => per_page, :media => 'photo', :sort => sort, :bbox => bbox}

  puts "\nSearching for interesting photos in #{country} => #{box.inspect} ..."
  photos = flickr.photos.search(opts)

  data = []
  photos.each do |photo|

    photo_id = photo.url.split('/')[-1]
    location_info = photo.location && "#{photo.location && photo.location.latitude},#{photo.location && photo.location.longitude}] (#{photo.location.accuracy})" || 'nil'
    puts "Views: #{photo.views}  Location: #{location_info} \tDate: #{photo.taken_at.to_s}  URL: #{photo.photopage_url}"
    data << {"country" => safe_country, "photo_id" => photo_id, "photopage_url" => photo.photopage_url, "owner" => photo.owner, "owner_realname" => photo.owner_realname, "taken_at" => photo.taken_at.strftime("%Y-%m-%d %H:%M:%S"), "updated_at" => photo.updated_at.strftime("%Y-%m-%d %H:%M:%S"), "lat" => photo.location.latitude, "lon" => photo.location.longitude, "views" => photo.views, "tags" => sanitize_tags(photo.tags)}

    # Data we want to dump:
    # - photo_pageurl, owner, owner_realname, taken_at, updated_at, latitude, longitude, views, tags
    # Things we need to add via secondary API calls:
    # - favorites, contexts (sets and pools)

    if ENV['OPEN']
      `open '#{photo.photopage_url}'`
    end

    if ENV['DOWNLOAD']
      agent = Mechanize.new
      agent.user_agent_alias = "Mac Safari"
      filename = "#{country_dir}/#{photo_id}"
      next if File.exists?(filename)
      agent.get(photo.url).save_as(filename)
    end
  end

  STDERR.puts "Dumping raw CSV data..."
  data_file = "#{country_dir}/data.csv"
  FasterCSV.open(data_file, "w") do |csv|
    headers = data.first.keys
    csv << headers
    data.each do |datum|
      csv << headers.collect{|header| datum[header] }
    end
  end

  data_files << data_file
end

# Combine all CSVs into one mega CSV
puts "\nCombining into one output CSV..."
puts data_files.inspect
output = "#{data_dir}/combined.csv"
header_done = false
data_files.each do |file|
  if header_done
    `sed '1d' '#{file}' >> '#{output}'`
  else
    `cat '#{file}' > '#{output}'`
    header_done = true
  end
end

puts "Done."
