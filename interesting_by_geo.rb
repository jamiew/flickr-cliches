#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'flickr_fu'

config = YAML.load(File.open(File.dirname(__FILE__)+'/config.yml'))
puts "config=#{config.inspect}"


