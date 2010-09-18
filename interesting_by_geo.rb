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

opts = {:media => 'photo', :sort => 'interestingness-desc'}
opts[:place_id] = 'fh4BQ2yYA5lK_1zfsw' # semi-random
# opts[:bbox] = config[:bounding_box] # TODO

puts "Searching for interesting photos..."
photos = flickr.photos.search(opts)

puts "1st photo = "
puts photos[0].inspect

puts "TODO doing something with these photos"

exit 0
