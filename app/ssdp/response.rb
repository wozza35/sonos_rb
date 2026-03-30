module SSDP
  class Response
    def initialize(raw_response)
      @headers = raw_response.lines.each_with_object({}) do |line, hash|
        key, value = line.split(':', 2)
        hash[key.upcase.strip] = value.strip if value
      end
    end

    def location
      @headers['LOCATION']
    end

    def search_target
      @headers['ST']
    end
  end
end
