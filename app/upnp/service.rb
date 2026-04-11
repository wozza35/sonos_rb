require 'rexml'
require_relative '../soap/request'

module UPnP
  class Service
    def initialize(attributes:, base_uri:)
      @service_type = attributes[:serviceType]
      @control_uri = URI.join(base_uri, attributes[:controlURL])
    end

    def name
      service_type.split(':')[-2]
    end

    def call(action)
      response = SOAP::Request.new(control_uri, action, service_type).perform
      REXML::Document.new(response.body)
    end

    private

    attr_reader :service_type, :control_uri
  end
end
