require 'magnetism/engine'
require 'magnetism/page_not_found'
require 'magnetism/cache'

# gems
require 'haml'
require 'devise'
require 'inherited_resources'
require 'layout_options'
require 'current_object'
require 'liquify'
require 'fog'
require 'mini_magick'
require 'carrierwave'

module Magnetism
  mattr_accessor :cache
  @@cache = :file_system

  mattr_accessor :cache_length
  @@cache_length = 300

  def self.setup
    yield(self)
  end

  def self.root
    File.expand_path(File.dirname(__FILE__) + '/..')
  end
end

