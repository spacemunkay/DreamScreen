require 'rubygems'
require 'RMagick'
require 'json'
include Magick


=begin
Dir.entries(dir_name).each do |filename|
  next if filename == "."
  next if filename == ".."

  img = ImageList.new(dir_name+ "/" + filename)
  img = img.transparent("#000000", Magick::TransparentOpacity)
  puts filename
  img.write(output_dir_name + "/" + filename)
end
=end
begin
  il = ImageList.new
  base = ImageList.new("test_source/thumbs_up.JPG")
  base.fuzz = 12500
  #light 46f75f
  light_green = '#46f75f'
  #mid 249523
  mid_green = '#249523'
  #dark 1d6c1d
  dark_green = '#1d6c1d'
  il << base.scale(0.25).opaque_channel(mid_green, "#000000").opaque_channel(light_green, "#000000")
  #test.resize_to_fill(800, 800)
  #final = other.transparent("#249523", Magick::TransparentOpacity)
  #final.write("test_out/thumbs_up.png")
  il.display
rescue
  puts "Caught exception: #{$!}"
end

exit

