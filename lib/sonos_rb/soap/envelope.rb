module SonosRB
  module SOAP
    class Envelope
      attr_reader :body

      def initialize(operation, namespace, args = {})
        @operation = operation
        @namespace = namespace
        @args = args
      end

      def to_xml
        <<~XML
          <?xml version="1.0" encoding="utf-8"?>
          <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <s:Body>
              #{action_element}
            </s:Body>
          </s:Envelope>
        XML
      end

      private

      attr_reader :operation, :namespace, :args

      def action_element
        return "<u:#{operation} xmlns:u=\"#{namespace}\"/>" if args.empty?

        children = args.map { |k, v| "      <#{k}>#{v}</#{k}>" }.join("\n")
        "<u:#{operation} xmlns:u=\"#{namespace}\">\n#{children}\n    </u:#{operation}>"
      end
    end
  end
end

