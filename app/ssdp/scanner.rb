require "socket"
require_relative "response"

module SSDP
  class Scanner
    SSDP_ADDRESS = "239.255.255.250"
    SSDP_PORT = 1900
    SEARCH_TARGET = "urn:schemas-upnp-org:device:ZonePlayer:1"
    TIMEOUT = 3

    SEARCH_MESSAGE = <<~MSG
      M-SEARCH * HTTP/1.1\r
      HOST: #{SSDP_ADDRESS}:#{SSDP_PORT}\r
      MAN: "ssdp:discover"\r
      MX: #{TIMEOUT}\r
      ST: #{SEARCH_TARGET}\r
      \r
    MSG

    def initialize
      @found_locations = []
    end

    def scan
      broadcast_search
      collect_responses
      found_locations
    ensure
      @socket&.close
    end

    private

    attr_reader :found_locations

    def broadcast_search
      @socket = UDPSocket.new
      @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
      @socket.send(SEARCH_MESSAGE, 0, SSDP_ADDRESS, SSDP_PORT)
    end

    def collect_responses
      loop do
        break unless IO.select([@socket], nil, nil, TIMEOUT)

        response = read_response
        if response.search_target == SEARCH_TARGET && response.location
          found_locations << response.location
        end
      end
    end

    def read_response
      data, _ = @socket.recvfrom(4096)
      Response.new(data)
    end
  end
end
