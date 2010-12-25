module Magnetism
  class PageNotFound < Exception
    def message
      'The page you requested does not exist'
    end
  end
end
