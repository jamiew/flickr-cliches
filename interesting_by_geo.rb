#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'fileutils'
require 'flickr_fu'

config_file = File.dirname(__FILE__)+'/config.yml'
config = YAML.load(File.open(config_file))

flickr = Flickr.new(config_file)
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
box = config["bounding_box"]
bbox = "#{box[0][1]},#{box[0][0]},#{box[1][1]},#{box[1][0]}"
opts = {:page => page, :per_page => per_page, :media => 'photo', :sort => sort, :bbox => bbox}

puts "Searching for interesting photos..."
photos = flickr.photos.search(opts)

data = []
photos.each do |photo|

  location_info = photo.location && "#{photo.location && photo.location.latitude},#{photo.location && photo.location.longitude}] (#{photo.location.accuracy})" || 'nil'
  puts "Views: #{photo.views}  Location: #{location_info} \tDate: #{photo.taken_at.to_s}  URL: #{photo.photopage_url}"

  # Data we want to dump:
  # - photo_pageurl, owner, owner_realname, taken_at, updated_at, latitude, longitude, views, tags
  # Things we need to add via secondary API calls:
  # - favorites, contexts (sets and pools)

  data << "#{photo.photopage_url},#{photo.owner},#{photo.owner_realname},#{photo.taken_at},#{photo.updated_at},#{photo.location && photo.location.latitude},#{photo.location && photo.location.longitude},#{photo.views},#{photo.tags}"

  if ENV['OPEN']
    `open '#{photo.photopage_url}'`
  end

  if ENV['DOWNLOAD']
    require 'mechanize'
    FileUtils.mkdir_p(File.dirname(__FILE__)+'/photos')

    agent = Mechanize.new
    agent.user_agent_alias = "Mac Safari"
    filename = File.dirname(__FILE__)+'/photos/'+photo.url.split('/')[-1]
    next if File.exists?(filename)
    agent.get(photo.url).save_as(filename)
  end

end


STDERR.puts "Dumping raw CSV data..."
# TODO fill this in
# output the 'data' array to a file
STDERR.puts data.inspect

exit 0
