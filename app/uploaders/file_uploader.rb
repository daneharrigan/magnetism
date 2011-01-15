# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience
  # DH: try them both out and see whats better


  def store_dir
    "assets/#{Site.current.key}/uploads/"
  end

  # DH: will come back to this
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Create different versions of your uploaded files:
  version :thumbnail do
    process :resize_to_fill => [100, 100]
  end

  def filename
    "#{model.id.to_s[0..4]}_#{original_filename}" if original_filename
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end
end
