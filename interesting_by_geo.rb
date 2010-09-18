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

per_page = ENV['PER_PAGE'] && ENV['PER_PAGE'].to_i || 10
opts = {:per_page => per_page, :media => 'photo', :sort => 'interestingness-desc'}
box = config["bounding_box"]
opts[:bbox] = "#{box[0][1]},#{box[0][0]},#{box[1][1]},#{box[1][0]}"

puts "Searching for interesting photos..."
photos = flickr.photos.search(opts)

photos.each do |photo|
  puts "Views: #{photo.views} \tLocation: #{photo.location.latitude},#{photo.location.longitude} \tURL: #{photo.photopage_url}"

  if ENV['OPEN']
    `open '#{photo.photopage_url}'`
  end

  if ENV['DOWNLOAD']
    require 'mechanize'
    FileUtils.mkdir_p(File.dirname(__FILE__)+'/photos')

    agent = Mechanize.new
    agent.user_agent_alias = "Mac Safari"
    filename = photo.url.split('/')[-1]
    agent.get(photo.url).save_as(File.dirname(__FILE__)+'/photos/'+filename)
  end

end

exit 0
