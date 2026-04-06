require_relative "base"

module CLI
  module Commands
    class Help < Base
      def self.command_name
        "help"
      end

      def self.help
        "Show available commands"
      end

      def execute
        CLI::Runner::COMMANDS.each { |cmd| puts "  #{cmd.command_name} - #{cmd.help}" }
      end
    end
  end
end
