class BigHomeSlideImageUploader < BaseImageUploader
  version :the_first do
    process resize_to_fill: [686, 686]
    process :optimize_for_pagespeed
  end

  version :other do
    process resize_to_fill: [686, 300]
    process :optimize_for_pagespeed
  end
end
