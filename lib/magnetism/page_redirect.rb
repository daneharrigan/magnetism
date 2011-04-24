module Magnetism
  class PageRedirect < Exception
    attr_accessor :page

    def initialize(page)
      self.page = page
    end

    def message
      'The page requested has been permanently moved'
    end
  end
end
