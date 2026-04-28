require 'sonos_rb/upnp/device'

module SonosRB
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

    def coordinator_udns
      service('ZoneGroupTopology').get_zone_group_state.coordinator_udns
    end

    private

    def service(name)
      services.find { |s| s.name == name }
    end
  end
end
