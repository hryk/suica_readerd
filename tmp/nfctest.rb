#!/usr/bin/ruby
require 'rubygems'
require 'nfc'

loop do
tag = NFC.instance.find
puts tag.to_s
end
