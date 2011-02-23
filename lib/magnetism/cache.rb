module Magnetism
  module Cache
    def self.included(base)
      base.send :before_filter, :magnetism_cache
    end

    def magnetism_cache
    end
  end
end
