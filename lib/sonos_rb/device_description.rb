require 'net/http'
require 'rexml/document'
require_relative '../xml/element_parser'
require_relative '../service'
require_relative 'zone_player'

module Sonos
  class DeviceDescription
    def initialize(location)
      @location = location
    end

    def fetch
      xml = Net::HTTP.get(location.uri)
      doc = REXML::Document.new(xml)

      build_zone_player(doc.root.elements['device'])
    end

    private

    attr_reader :location

    def build_zone_player(element)
      ZonePlayer.new(
        XML::ElementParser.parse(element),
        services: build_services(element),
        embedded_devices: build_embedded_devices(element)
      )
    end

    def build_embedded_devices(element)
      device_list = element.elements['deviceList']
      return [] unless device_list

      device_list.elements.collect('device') do |device_xml|
        UPnP::Device.new(XML::ElementParser.parse(device_xml), services: build_services(device_xml))
      end
    end

    def build_services(element)
      service_list = element.elements['serviceList']
      return [] unless service_list

      service_list.elements.collect('service') do |service_xml|
        Service.build(attributes: XML::ElementParser.parse(service_xml), base_uri: location.uri)
      end
    end
  end
end
