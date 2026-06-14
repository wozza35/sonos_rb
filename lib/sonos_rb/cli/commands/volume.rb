require_relative "base"

module SonosRB
  module CLI
    module Commands
      class Volume < Base
        def self.command_name
          "volume"
        end

        def self.help
          "Display or set the volume for the selected coordinator"
        end

        def execute
          unless store.selected_coordinator
            puts "No coordinator selected. Use 'select' to choose one."
            return
          end

          current = store.selected_coordinator.volume
          puts "Current volume: #{current}"

          puts "Enter new volume (0-100), or press enter to skip: "
          input = gets&.strip
          return if input.nil? || input.empty?

          level = input.to_i
          if level >= 0 && level <= 100
            store.selected_coordinator.volume = level
            puts "Volume set to #{level}"
          else
            puts "Invalid volume. Please enter a number between 0 and 100."
          end
        end
      end
    end
  end
end
