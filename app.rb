require 'rubygems'
require 'sinatra'
require 'haml'
require File.expand_path(File.dirname(__FILE__) + "/dreamscreen")

def base_name(fname)
  fname.split(".")[0]
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
  raw_images.to_json
end

get '/background' do
  content_type :json
  bg_images.to_json
end

get '/screened' do
  content_type :json
  screened_images.to_json
end

get '/out' do
  content_type :json
  out_images.to_json
end
