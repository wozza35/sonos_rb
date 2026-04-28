require 'sonos_rb/cli/commands/exit'
require 'sonos_rb/cli/commands/help'
require 'sonos_rb/cli/commands/scan'
require 'sonos_rb/cli/commands/select'
require 'sonos_rb/cli/session'
require 'readline'

module SonosRB
  module CLI
    class Runner
      COMMANDS = [
        Commands::Help,
        Commands::Exit,
        Commands::Scan,
        Commands::Select,
      ].freeze

      HINT = "Type 'help' for a list of commands, 'exit' to quit."
      UNKNOWN_COMMAND = "Unknown command: '%s'. #{HINT}"

      def initialize(store = Session.new)
        @store = store
        @command_lookup = COMMANDS.each_with_object({}) { |cmd, h| h[cmd.command_name] = cmd }
      end

      def start
        puts "SonosRB CLI started"
        puts HINT

        while (line = Readline.readline('> ', true)) do
          run_command(line)
        end
      end

      private

      def run_command(name)
        command_class = @command_lookup[name]
        if command_class
          command_class.new(@store).execute
        else
          puts UNKNOWN_COMMAND % name
        end
      end
    end
  end
end
