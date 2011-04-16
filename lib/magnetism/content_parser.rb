require 'coderay'

module Magnetism
  class ContentParser
    def initialize(content)
      @content = textile parse_tags(content)
    end

    def invoke
      @content
    end

    def code(content, params)
      CodeRay.scan(content, params['lang']).div(:css => :class)
    end

    private
      def parse_tags(content)
        available_methods = public_methods(false) - [:invoke]
        available_methods.each do |tag|
          content.gsub!(/<m:#{tag}([^>]*)>(.*?)<\/m:#{tag}>/m) do |match|
            formatted_content = send(tag, $2, parse_params($1))

            "<notextile>#{formatted_content}</notextile>"
          end
        end

        return content
      end

      def textile(content)
        return unless content.present?
        RedCloth.new(content).to_html
      end

      def parse_params(string)
        params = {}
        string.scan(/([^ =]+)="([^"]*)"/).each { |match| params[match[0]] = match[1] }

        return params
      end
  end
end
