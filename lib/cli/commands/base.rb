module CLI
  module Commands
    class Base
      def initialize(store)
        @store = store
      end

      def self.command_name
        raise NotImplementedError
      end

      def self.help
        raise NotImplementedError
      end

      def execute
        raise NotImplementedError
      end

      private

      attr_reader :store
    end
  end
end
