class BaseImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  #   # process resize_to_fill: [100,100]
  #   # process resize_to_limit: [200,200]
  #   # process :grayscale
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # def image?(_ = nil)
  #   self.file.content_type.include? 'image'
  # end

  # Returns string like "#{width}x#{height}" or nil
  # def geom_sizes_string
  #   unless self.blank?
  #     image = MiniMagick::Image::open self.current_path
  #     "#{image[:width]}x#{image[:height]}"
  #   end
  # end

  protected

  # def grayscale()
  #   manipulate! do |img|
  #     img.colorspace('Gray')
  #     img
  #   end
  # end

  # def is_landscape? picture
  #   image = MiniMagick::Image.open(picture.path)
  #   image[:width] > image[:height]
  # end

  def optimize_for_pagespeed
    # according to https://developers.google.com/speed/docs/insights/OptimizeImages
    if self.file.content_type == 'image/jpeg'
      # convert orig.jpg -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG orig_converted.jpg
      manipulate! do |img|
        img.sampling_factor '4:2:0'
        img.strip
        img.quality 85
        img.interlace 'JPEG'
        img
      end
    else
      # convert cuppa.png -strip cuppa_converted.png
      manipulate! do |img|
        img.strip
        img
      end
    end
  end

end
