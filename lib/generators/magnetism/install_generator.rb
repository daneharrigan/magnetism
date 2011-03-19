module Magnetism
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Copy Magnetism installation files'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializers
        copy_file 'magnetism.rb', 'config/initializers/magnetism.rb'
        copy_file 'carrierwave.rb', 'config/initializers/carrierwave.rb'
      end
    end
  end
end
