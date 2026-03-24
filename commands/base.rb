module Commands
  class Base
    def self.command_name
      raise NotImplementedError
    end

    def self.help
      raise NotImplementedError
    end

    def execute
      raise NotImplementedError
    end
  end
end
