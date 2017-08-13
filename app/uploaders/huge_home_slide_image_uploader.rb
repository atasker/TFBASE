class HugeHomeSlideImageUploader < BaseImageUploader
  process resize_to_limit: [1980, 685]

  version :thumb do
    process resize_to_limit: [396, 137]
  end
end
