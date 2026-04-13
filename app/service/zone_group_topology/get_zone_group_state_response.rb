require 'rexml/document'
require_relative '../base'

module Service
  class ZoneGroupTopology < Base
    class GetZoneGroupStateResponse
      def initialize(response)
        @response = response
      end

      def coordinator_udns
        zone_groups.map { |group| "uuid:#{group.attributes['Coordinator']}" }
      end

      private

      def zone_groups
        state_doc.elements.collect('ZoneGroupState/ZoneGroups/ZoneGroup') { |e| e }
      end

      def state_doc
        @state_doc ||= REXML::Document.new(zone_group_state)
      end

      def zone_group_state
        @response.elements['//ZoneGroupState'].text
      end
    end
  end
end
