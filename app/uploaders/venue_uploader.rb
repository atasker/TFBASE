class VenueUploader < BaseImageUploader
  version :venue do
    process resize_to_fill: [1000, 1000]
  end

  version :venue_thumb do
    process resize_to_fill: [400, 200]
  end
end
