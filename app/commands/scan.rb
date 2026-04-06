require_relative "base"
require_relative "../ssdp/scanner"
require_relative "../sonos/device_description"

module Commands
  class Scan < Base
    def self.command_name
      "scan"
    end

    def self.help
      "Scan the network for Sonos devices"
    end

    def execute
      puts "Scanning for Sonos devices..."
      locations = SSDP::Scanner.new.scan

      if locations.empty?
        puts "No devices found."
        return
      end

      locations.each_with_index do |location, i|
        puts "\n#{i + 1}:"
        puts " #{location}"
        zone_player = Sonos::DeviceDescription.new(location).fetch
        display_zone_player(zone_player)
      end
    end

    private

    def display_zone_player(zone_player)
      puts "  Room: #{zone_player.room_name} "
      puts "  Display name: #{zone_player.display_name}"
      puts "  Model: #{zone_player.model_name} (#{zone_player.model_number})"

      puts "  Services:"
      zone_player.services.each do |service|
        puts "    #{service.name}"
      end

      puts "  Embedded devices:"
      zone_player.embedded_devices.each do |device|
        puts "    #{device.model_description}"
        puts "    Services:"
        device.services.each do |service|
          puts "      #{service.name}"
        end
      end
    end
  end
end
