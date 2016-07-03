# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # version :tiny do
  #   process resize_to_fill: [160, 100]
  # end

  version :grid_large do
    process resize_to_fill: [400, 450]
  end

  version :grid_small do
    process resize_to_fill: [400, 300]
  end

end
