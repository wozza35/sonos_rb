require_relative 'base'
require_relative 'zone_group_topology/get_zone_group_state_response'

module Service
  class ZoneGroupTopology < Base
    def get_zone_group_state
      GetZoneGroupStateResponse.new(call('GetZoneGroupState'))
    end
  end
end
