require 'rexml/text'

module SonosRB
  module SOAP
    class Envelope
      def initialize(operation, namespace, arguments = {})
        @operation = operation
        @namespace = namespace
        @arguments = arguments
      end

      def to_xml
        [
          %(<?xml version="1.0" encoding="utf-8"?>),
          %(<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">),
          %(  <s:Body>),
          operation_xml,
          %(  </s:Body>),
          %(</s:Envelope>),
        ].join("\n") + "\n"
      end

      private

      attr_reader :operation, :namespace, :arguments

      def operation_xml
        if arguments.empty?
          %(    <u:#{operation} xmlns:u="#{namespace}"/>)
        else
          [
            %(    <u:#{operation} xmlns:u="#{namespace}">),
            arguments_xml,
            %(    </u:#{operation}>),
          ].join("\n")
        end
      end

      def arguments_xml
        arguments.map do |key, value|
          "      <#{key}>#{REXML::Text.normalize(value.to_s)}</#{key}>"
        end.join("\n")
      end
    end
  end
end
