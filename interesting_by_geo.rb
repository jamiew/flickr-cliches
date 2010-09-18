#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'flickr_fu'

config_file = File.dirname(__FILE__)+'/config.yml'
config = YAML.load(File.open(config_file))
puts "config=#{config.inspect}"

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

opts = {:per_page => 10, :media => 'photo', :sort => 'interestingness-desc'}
# opts[:place_id] = 'fh4BQ2yYA5lK_1zfsw' # semi-random
box = config["bounding_box"]
# bbox arg = min long, min lat, max long, max lat
opts[:bbox] = "#{box[0][1]},#{box[0][0]},#{box[1][1]},#{box[1][0]}"
puts opts[:bbox].inspect

puts "Searching for interesting photos..."
photos = flickr.photos.search(opts)
photos.each do |photo|
  puts "Views: #{photo.views} \tLocation: #{photo.location.latitude},#{photo.location.longitude} \tURL: #{photo.photopage_url}"
  `open '#{photo.photopage_url}'` if ENV['OPEN']
end

exit 0
