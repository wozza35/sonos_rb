require_relative '../upnp/device'

module Sonos
  class ZonePlayer < UPnP::Device
    def room_name
      attributes[:roomName]
    end

    def display_name
      attributes[:displayName]
    end

    def software_version
      attributes[:softwareVersion]
    end

    def hardware_version
      attributes[:hardwareVersion]
    end

    def serial_number
      attributes[:serialNum]
    end

    def mac_address
      attributes[:MACAddress]
    end

    def zone_type
      attributes[:zoneType]
    end
  end
end
