require 'rails'

module Magnetism
  class Engine < Rails::Engine
    %W(drops tags filters blocks).each do |dir|
      config.autoload_paths << File.expand_path(File.dirname(__FILE__) + "/../../app/#{dir}")
    end

    initializer 'magnetism.initializer' do |app|
      app.config.filter_parameters += [:login, :email, :password, :password_confirmation]

      #app.config.i18n.load_path += Dir[Magnetism.root + '/config/locales/*.yml']
    end
  end
end
