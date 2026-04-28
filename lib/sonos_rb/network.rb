require 'sonos_rb/ssdp/scanner'
require 'sonos_rb/device_description'

module SonosRB
  class Network
    SEARCH_TARGET = "urn:schemas-upnp-org:device:ZonePlayer:1"

    attr_reader :zone_players

    def self.discover
      locations = SSDP::Scanner.new(SEARCH_TARGET).scan
      zone_players = locations.map { |loc| DeviceDescription.new(loc).fetch }
      new(zone_players)
    end

    def initialize(zone_players)
      @zone_players = zone_players
    end

    def coordinators
      zone_players.select do |zone_player|
        coordinator_udns.include?(zone_player.udn)
      end
    end

    private

    def coordinator_udns
      @coordinator_udns ||= zone_players.first.coordinator_udns
    end
  end
end
