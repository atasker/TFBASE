# encoding: utf-8

class VenueUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :venue do
    process resize_to_fill: [1000, 1000]
  end

  version :venue_thumb do
    process resize_to_fill: [400, 200]
  end

end
