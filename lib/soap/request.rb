require 'net/http'
require_relative 'envelope'

module SOAP
  class Request
    def initialize(uri, operation, namespace)
      @uri = uri
      @operation = operation
      @namespace = namespace
    end

    def perform
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.request(build_post)
    end

    private

    attr_reader :uri, :operation, :namespace

    def build_post
      Net::HTTP::Post.new(uri).tap do |request|
        request.initialize_http_header(headers)
        request.body = request_body
      end
    end

    def headers
      {
        'Content-Type' => 'text/xml; charset="utf-8"',
        'SOAPACTION' => "\"#{namespace}##{operation}\"",
      }
    end

    def request_body
      Envelope.new(operation, namespace).to_xml
    end
  end
end
