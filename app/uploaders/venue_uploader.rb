class VenueUploader < BaseImageUploader
  version :venue do
    process resize_to_fill: [1000, 1000]
    process :optimize_for_pagespeed
  end

  version :venue_thumb do
    process resize_to_fill: [400, 200]
    process :optimize_for_pagespeed
  end
end
