# -*- encoding : utf-8 -*-

#TODO: Improve documentation
module USPSStandardizer
  require "usps_standardizer/version"
  require "usps_standardizer/zip_lookup"
  require "usps_standardizer/configuration"
  require "usps_standardizer/cache"

  class << self

    def lookup_for(options)
      z = ZipLookup.new(options)
      z.std_address
    end

    def cache
      if @cache.nil? and store = Configuration.cache
        @cache = Cache.new(store, Configuration.cache_prefix)
      end
      @cache
    end

  end

end
