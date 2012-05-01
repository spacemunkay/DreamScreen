require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

require File.expand_path(File.dirname(__FILE__) + "/dreamscreen")

def base_name(fname)
  fname.split(".")[0]
end

get '/test' do
  haml :test
end

get '/' do
  @raw_images = ::DreamScreen.raw_images.take(10)
  haml :index
end

get '/choose_background' do
  @fname = params["fname"]
  @bg_images = ::DreamScreen.bg_images 
  if (!::DreamScreen.screened_images.include?(@fname))
    img = ::DreamScreen.remove_green(@fname)
    ::DreamScreen.save_screen( base_name(@fname) + ".png" , img) 
  end

  haml :background
end

get '/finish' do
  @fname = params["fname"]
  @bg_name = params["bgname"]
  
  img = ::DreamScreen.merge_background( base_name(@fname) + ".png", @bg_name) 
  name = Time.now.getutc.to_s
  @name = base_name(@fname) + "_" + base_name(@bg_name) + "_" + name.split(" ").join("_") + ".png"
  ::DreamScreen.save_image( @name , img) 

  @out_images = ::DreamScreen.out_images 
  haml :finish
end

get '/error' do
  @error = params["error"]
  haml :error
end

get '/raw' do
  content_type :json
  ::DreamScreen.raw_images.map{ |x| {:path => x} }.to_json
end

get '/background' do
  content_type :json
  ::DreamScreen.bg_images.map{ |x| {:path => x} }.to_json
end

get '/screened' do
  content_type :json
  ::DreamScreen.screened_images.map{ |x| {:path => x} }.to_json
end

get '/out' do
  content_type :json
  ::DreamScreen.out_images.map{ |x| {:path => x} }.to_json
end

post '/merge' do
  content_type :json
  data = JSON.parse(request.body.read)
  @fname = data["front"]
  @bg_name = data["bg"]
  img = ::DreamScreen.merge_background( base_name(@fname) + ".png", @bg_name) 
  name = Time.now.getutc.to_s
  @name = base_name(@fname) + "_" + base_name(@bg_name) + "_" + name.split(" ").join("_") + ".png"
  ::DreamScreen.save_image( @name , img)
end
