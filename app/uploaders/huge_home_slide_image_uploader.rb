class HugeHomeSlideImageUploader < BaseImageUploader
  process resize_to_limit: [1980, 685]
end
