module Magnetism
  module Cache
    def self.included(base)
      if Magnetism.cache == :varnish
        base.send(:before_filter, :varnish_cache)
        base.send(:after_filter, :update_page_cache)
      end

      base.send(:after_filter, :file_system_cache) if Magnetism.cache == :file_system
    end

    private
      def varnish_cache
        response.headers['Cache-Control'] = "public, max-age=#{Magnetism.cache_length}"
      end

      def update_page_cache
        page = self.instance_variable_get(:@page)
        page.update_attribute(:cached_at, Time.now)
      end

      def file_system_cache
        file_path = Rails.public_path + '/cache' + request.path + '.html'
        directory_path = file_path.split('/')
        directory_path.pop
        directory_path = directory_path.join('/')

        FileUtils.mkdir_p(directory_path)
        File.open(file_path, 'w') { |f| f.write(response.body) }
      end
  end
end
