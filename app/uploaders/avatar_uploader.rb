class AvatarUploader < BaseImageUploader
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
