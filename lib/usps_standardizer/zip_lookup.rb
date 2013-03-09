# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'yaml'

module USPSStandardizer
  #TODO: Implement 'timeout'
  
  class Error < ArgumentError
  end

  class ZipLookup

    attr_accessor :address, :state, :city, :zipcode

    def initialize(options = {})
      @address, @state, @city, @zipcode, @county = '', '', '', '', ''
      options.each do |name, value|
        send("#{name}=", value)
      end
    end

    def std_address
      if cache
        response = cache[redis_key(@address)]
        return YAML.load(response) if response
      end

      result = get_std_address_content
      if cache
        cache[redis_key(@address)] = result.to_yaml
      end
      result
    end

    private

    def get_std_address_content
      url = URI.escape("https://tools.usps.com/go/ZipLookupResultsAction!input.action?resultMode=0&companyName=&address1=#{@address}&address2=&city=#{@city}&state=#{@state}&urbanCode=&postalCode=&zip=#{@zipcode}")
      @doc = Nokogiri::HTML(open(url))
      
      error = @doc.css('p#nonDeliveryMsg').first || @doc.css('p.multi').first || @doc.css('div.noresults-container .error').first
      if error
        raise Error.new(error.content)
      end
      
      {
        :address => @doc.css('span.address1').first.content.strip,
        :city => @doc.css('span.city').first.content.strip,
        :state => @doc.css('span.state').first.content.strip,
        :zipcode => @doc.css('span.zip').first.content.strip
      }
    end

    def cache
      USPSStandardizer.cache
    end

    private
    def redis_key(address)
      address.downcase.gsub(' ', '_')
    end
  end
end
