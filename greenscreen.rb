require 'RMagick'
include Magick

OUT_DIR_PATH = "public/images/final"
BG_DIR_PATH = "public/images/bg"
SCREEN_DIR_PATH = "public/images/screened"
RAW_DIR_PATH = "public/images/raw"

def get_filenames(dir)
    fnames = []
    sorted_files = Dir.entries(dir).sort_by{ |f| File.ctime(dir + "/" + f) }.reverse
    sorted_files.each do |filename|
      next if filename == "."
      next if filename == ".."
      fnames << filename
    end
    return fnames
end
=begin
def class ThumbnailManager
  attr_accessor :thumb_fnames, :dir
  
  def initialize(dir_path)
    @dir = dir_path
    @thumb_fnames = get_filenames(dir_path)
  end
end
=end 

#get images in directories
def raw_images
  fnames = get_filenames(RAW_DIR_PATH)
  return fnames
end

def screened_images
  fnames = get_filenames(SCREEN_DIR_PATH)
  return fnames
end

def bg_images
  fnames = get_filenames(BG_DIR_PATH)
  return fnames
end

def out_images
  fnames = get_filenames(OUT_DIR_PATH)
  return fnames
end

def remove_green(filename)
  begin
    il = ImageList.new
    temp = ImageList.new
    base = ImageList.new(RAW_DIR_PATH + "/" + filename)

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
    #puts il.inspect
    final = il.cur_image
    return final
  rescue
    puts "Caught exception: #{$!}"
    return nil
  end
end

def merge_background(filename, bg_fname)
  begin
    il = ImageList.new
    base = ImageList.new(SCREEN_DIR_PATH + "/" + filename)
    bg = ImageList.new(BG_DIR_PATH + "/" + bg_fname)

    il << bg.resize_to_fill(base.columns, base.rows)
    il << base.cur_image
    return il.flatten_images
  rescue
    puts "Caught exception: #{$!}"
    return nil
  end
end

def save_image(filename, img)
  begin
    img.write(OUT_DIR_PATH + "/" + filename) 
    return true
  rescue
    puts "Caught exception: #{$!}"
    return false
  end
end

def save_screen(filename, img)
  begin
    img.write(SCREEN_DIR_PATH + "/" + filename) 
    return true
  rescue
    puts "Caught exception: #{$!}"
    return false
  end
end


