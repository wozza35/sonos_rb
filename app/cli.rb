require_relative "commands/exit"
require_relative "commands/help"
require_relative "commands/scan"
require 'readline'

class CLI
  COMMANDS = [
    Commands::Help,
    Commands::Exit,
    Commands::Scan,
  ].freeze

  HINT = "Type 'help' for a list of commands, 'exit' to quit."
  UNKNOWN_COMMAND = "Unknown command: '%s'. #{HINT}"

  def initialize
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
      command_class.new.execute
    else
      puts UNKNOWN_COMMAND % name
    end
  end
end
