require 'uri'

module SSDP
  class Location
    def initialize(url)
      @url = url
    end

    def ip
      uri.host
    end

    def port
      uri.port
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def to_s
      "#{ip}:#{port}"
    end

    private

    attr_reader :url
  end
end
