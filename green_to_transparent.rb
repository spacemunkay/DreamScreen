require 'rubygems'
require 'RMagick'
require 'json'
include Magick

def remove_green(dir, filename)
  begin
    il = ImageList.new
    temp = ImageList.new
    base = ImageList.new(dir + "/" + filename)
    #light 46f75f
    light_green = '#46f75f'
    #mid 249523
    mid_green = '#249523'
    #dark 1d6c1d
    #dark_green = '#102d0f'
    dark_green = '#184117'
    
    #first pass
    base.fuzz = 1700
    temp << base.scale(0.25).opaque_channel(dark_green, mid_green)
    #second pass
    second_pass = temp.flatten_images
    second_pass.fuzz = 12500
    il << second_pass.opaque_channel(mid_green, light_green).opaque_channel(light_green, light_green).transparent(light_green, Magick::TransparentOpacity)
    #final.write("test_out/thumbs_up.png")
    #puts il.inspect
    il.display
  rescue
    puts "Caught exception: #{$!}"
    exit
  end
end

dir_name = "test_source"
output_dir_name = "test_out"
Dir.entries(dir_name).each do |filename|
  next if filename == "."
  next if filename == ".."
  remove_green(dir_name, filename)
end

#remove_green(dir_name, "thumbs_up.JPG")
exit



    #test.resize_to_fill(800, 800)
