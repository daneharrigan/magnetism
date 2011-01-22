require 'rails'

module Magnetism
  class Engine < Rails::Engine
    %W(drops tags filters).each do |dir|
      config.autoload_paths << File.expand_path(File.dirname(__FILE__) + "/../../app/#{dir}")
    end

    initializer 'magnetism.initializer' do |app|
      app.config.filter_parameters += [:login, :email, :password, :password_confirmation]
    end
  end
end
