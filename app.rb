require 'rubygems'
require 'sinatra'
require 'haml'
require 'greenscreen.rb'


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
  @name = @fname + "_" + @bg_name + "_" + name.split(" ").join("_") + ".png"
  save_image( @name , img) 

  @out_images = out_images 
  haml :finish
end

get '/error' do
  @error = params["error"]
  haml :error
end
