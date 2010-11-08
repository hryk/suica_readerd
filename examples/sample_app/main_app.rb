#!/usr/bin/ruby

require 'rubygems'
require 'sinatra'
require 'httpclient'

PUBLIC_API_HOME = 'http://masui.sfc.keio.ac.jp/orf09/'
API_HOME = 'http://masui.sfc.keio.ac.jp/orf09/admin/'

'admin/exist_id/'
configure do
  set :root, File.dirname(File.expand_path(__FILE__))
  set :public, Proc.new { root + '/public' }
end

get '/' do
  erb :main
end

get '/touched/:base/:id' do
  hc = HTTPClient.new
  STDERR.puts params[:id] + " exist?"
  res = hc.get_content(API_HOME + 'exist_id/' + params[:id])
  STDERR.puts res

  if /True/ =~ res
    erb :touch
  else
    STDERR.puts PUBLIC_API_HOME + params[:id] + '/' + params[:base]
    hc.get_content(PUBLIC_API_HOME + params[:id] + '/' + params[:base])
    redirect PUBLIC_API_HOME + 'register/' + params[:id]
  end
end

get '/test' do
    erb :touch
end
