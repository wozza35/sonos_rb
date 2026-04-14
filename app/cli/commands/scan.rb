require_relative "base"
require_relative "../../sonos/network"

module CLI
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
        network = Sonos::Network.discover

        if network.zone_players.empty?
          puts "No devices found."
          return
        end

        network.zone_players.each_with_index do |zone_player, i|
          puts "\n#{i + 1}:"
          display_zone_player(zone_player)
        end

        puts "\nCoordinators:"
        network.coordinators.each do |coordinator|
          puts "  #{coordinator.room_name} (#{coordinator.display_name})"
        end
      end

      private

      def display_zone_player(zone_player)
        puts "  Room: #{zone_player.room_name}"
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
end
