require_relative 'base'

module SonosRB
  module CLI
    module Commands
      class Volume < Base
        USAGE = "Usage: volume [0-100]".freeze
        NO_SELECTION = "No coordinator selected. Use 'select' first.".freeze
        INVALID_LEVEL = "Volume must be an integer between 0 and 100.".freeze

        def self.command_name
          'volume'
        end

        def self.help
          'Show the current volume or set it to an integer between 0 and 100'
        end

        def execute(args = [])
          coordinator = store.selected_coordinator
          unless coordinator
            puts NO_SELECTION
            return
          end

          if args.empty?
            puts "Current volume: #{coordinator.volume}"
            return
          end

          if args.length > 1
            puts USAGE
            return
          end

          level = parse_level(args.first)
          return unless level

          coordinator.volume = level
          puts "Volume set to #{level}"
        end

        private

        def parse_level(value)
          level = Integer(value, 10)
          return level if (0..100).cover?(level)

          puts INVALID_LEVEL
          nil
        rescue ArgumentError
          puts INVALID_LEVEL
          nil
        end
      end
    end
  end
end
