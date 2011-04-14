require 'magnetism/engine'
require 'magnetism/page_not_found'
require 'magnetism/cache'
require 'magnetism/content_parser'

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
require 'redcloth'

module Magnetism
  mattr_accessor :cache
  @@cache = :file_system

  mattr_accessor :cache_length
  @@cache_length = 300

  mattr_accessor :defensio_key
  @@defensio_key = nil

  def self.setup
    yield(self)
  end

  def self.root
    File.expand_path(File.dirname(__FILE__) + '/..')
  end

  def self.stylesheet_root
    self.root + '/app/views/admin/support_files/stylesheets'
  end

  def self.javascript_root
    self.root + '/app/views/admin/support_files/javascripts'
  end

  #def self.image_root
  #  self.root + '/app/views/admin/support_files/images'
  #end
end

