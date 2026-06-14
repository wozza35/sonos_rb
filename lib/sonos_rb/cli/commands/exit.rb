require_relative "base"

module SonosRB
  module CLI
    module Commands
      class Exit < Base
        def self.command_name
          "exit"
        end

        def self.help
          "Exit the CLI"
        end

        def execute(_args = [])
          exit(0)
        end
      end
    end
  end
end
