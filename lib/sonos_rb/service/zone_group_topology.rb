require 'sonos_rb/service/base'
require 'sonos_rb/service/zone_group_topology/get_zone_group_state_response'

module SonosRB
  module Service
    class ZoneGroupTopology < Base
      def get_zone_group_state
        GetZoneGroupStateResponse.new(call('GetZoneGroupState'))
      end
    end
  end
end
