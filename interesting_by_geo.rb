#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'flickr_fu'

config_file = File.dirname(__FILE__)+'/config.yml'
config = YAML.load(File.open(config_file))
puts "config=#{config.inspect}"

puts "Authorizing Flickr..."
puts "This will launch your web browser (on a Mac)."
puts "Press 'enter' after authorizing to continue."
flickr = Flickr.new(config_file)
puts flickr.inspect
auth_url = flickr.auth.url(:read)
`open '#{auth_url}'` # Fire up your browser
gets
flickr.auth.cache_token

opts = {:media => 'photo', :sort => 'interestingness-desc'}
opts[:place_id] = 'fh4BQ2yYA5lK_1zfsw' # semi-random
# opts[:bbox] = config[:bounding_box] # TODO

puts "Searching for interesting photos..."
photos = flickr.photos.search(opts)


puts "TODO doing something with these photos"

exit 0


