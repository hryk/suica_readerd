#!/usr/bin/env ruby
#
# policyd.rb
# Simple socket policy file server
#
# 
# Logs to stdout
#

if FileTest.file? "#{File.dirname(File.expand_path(__FILE__))}/../Gemfile"
  require "#{File.dirname(File.expand_path(__FILE__))}/../vendor/gems/environment"
  $: << "#{File.dirname(File.expand_path(__FILE__))}/../lib"
else
  require 'rubygems'
end

require 'eventmachine'
require 'rocket/policy'
require 'optparse'

options = {
  :port => 843,
  :file => nil
}

opts = OptionParser.new
opts.banner = "Usage: policy.rb [options]"

opts.on("-p [VAL]", "--port", "Port", Integer ) do |m|
  options[:port] = m
end

opts.on("-f [VAL]", "--file", String, "Policy file.") do |v|
  options[:file] = v
end

opts.parse!(ARGV)

EM.run do
  Rocket::Policy.start('127.0.0.1', options[:port], options[:file])
end
