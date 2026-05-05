module SonosRB
  module SOAP
    class Envelope
      attr_reader :body

      def initialize(operation, namespace)
        @operation = operation
        @namespace = namespace
      end

      def to_xml
        <<~XML
          <?xml version="1.0" encoding="utf-8"?>
          <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <s:Body>
              <u:#{operation} xmlns:u="#{namespace}"/>
            </s:Body>
          </s:Envelope>
        XML
      end

      private

      attr_reader :operation, :namespace
    end
  end
end
