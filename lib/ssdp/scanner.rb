require "socket"
require_relative "response"

module SSDP
  class Scanner
    SSDP_ADDRESS = "239.255.255.250"
    SSDP_PORT = 1900
    TIMEOUT = 3

    def initialize(search_target)
      @found_locations = []
      @search_target = search_target
    end

    def scan
      broadcast_search
      collect_responses
      found_locations
    ensure
      @socket&.close
    end

    private

    attr_reader :found_locations, :search_target

    def broadcast_search
      @socket = UDPSocket.new
      @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
      @socket.send(search_message, 0, SSDP_ADDRESS, SSDP_PORT)
    end

    def collect_responses
      loop do
        break unless IO.select([@socket], nil, nil, TIMEOUT)

        response = read_response
        if response.search_target == search_target && response.location
          found_locations << response.location
        end
      end
    end

    def read_response
      data, _ = @socket.recvfrom(4096)
      Response.new(data)
    end

    def search_message
      <<~MSG
        M-SEARCH * HTTP/1.1\r
        HOST: #{SSDP_ADDRESS}:#{SSDP_PORT}\r
        MAN: "ssdp:discover"\r
        MX: #{TIMEOUT}\r
        ST: #{search_target}\r
        \r
      MSG
    end
  end
end
