class BigHomeSlideImageUploader < BaseImageUploader
  version :the_first do
    process resize_to_fill: [686, 686]
  end

  version :other do
    process resize_to_fill: [686, 300]
  end
end
