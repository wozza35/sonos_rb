require_relative 'base'

module Service
  class ZoneGroupTopology < Base
    def get_zone_group_state
      GetZoneGroupStateResponse.new(call('GetZoneGroupState'))
    end
  end
end
