class TileHomeSlideImageUploader < BaseImageUploader
  process resize_to_fill: [695, 575]
  process :optimize_for_pagespeed
end
