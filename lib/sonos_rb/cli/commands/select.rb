require 'sonos_rb/cli/commands/base'
require 'sonos_rb/network'

module SonosRB
  module CLI
    module Commands
      class Select < Base
        def self.command_name
          "select"
        end

        def self.help
          "Select a Sonos coordinator to control"
        end

        def execute
          unless store.network
            puts "Scanning for Sonos devices..."
            store.network = Network.discover
          end

          coordinators = store.network.coordinators
          if coordinators.empty?
            puts "No coordinators found."
            return
          end

          coordinators.each_with_index do |zp, i|
            puts "  #{i + 1}. #{zp.room_name} (#{zp.display_name})"
          end

          selection = prompt_for_selection(coordinators.size)
          return unless selection

          store.selected_coordinator = coordinators[selection]
          puts "Selected: #{store.selected_coordinator.room_name}"
        end

        private

        def prompt_for_selection(size)
          puts "\nSelect (1-#{size}): "
          input = gets&.strip
          return if input.nil? || input.empty?

          index = input.to_i - 1
          if index >= 0 && index < size
            index
          else
            puts "Invalid selection."
            nil
          end
        end
      end
    end
  end
end
