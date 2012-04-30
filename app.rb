require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

#puts File.dirname(__FILE__)
require File.expand_path(File.dirname(__FILE__) + "/greenscreen")
#require 'greenscreen'


get '/' do
  @raw_images = raw_images 
  haml :index
end

get '/choose_background' do
  @fname = params["fname"]
  @bg_images = bg_images 
  if (!screened_images.include?(@fname))
    img = remove_green(@fname)
    name = @fname.split(".")[0] + ".png"
    save_screen( name , img) 
  end

  haml :background
end

get '/finish' do
  @fname = params["fname"]
  @bg_name = params["bgname"]
  
  img = merge_background(@fname.split(".")[0] + ".png", @bg_name) 
  name = Time.now.getutc.to_s
  @name = @fname.split(".")[0]+ "_" + @bg_name.split(".")[0] + "_" + name.split(" ").join("_") + ".png"
  save_image( @name , img) 

  @out_images = out_images 
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
