# -*- encoding : utf-8 -*-

#TODO: Improve documentation
module USPSStandardizer
  autoload :Version, "usps_standardizer/version"
  autoload :ZipLookup, "usps_standardizer/zip_lookup"
  autoload :Configuration, "usps_standardizer/configuration"
  autoload :Cache, "usps_standardizer/cache"

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
