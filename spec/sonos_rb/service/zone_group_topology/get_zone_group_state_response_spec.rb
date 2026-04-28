require 'rexml/document'
require_relative '../../../lib/service/zone_group_topology/get_zone_group_state_response'

describe Service::ZoneGroupTopology::GetZoneGroupStateResponse do
  let(:fixture) { File.read('spec/fixtures/get_zone_group_state_response.xml') }
  let(:response) { REXML::Document.new(fixture) }
  let(:unit) { described_class.new(response) }

  describe '#coordinator_udns' do
    subject { unit.coordinator_udns }

    it { is_expected.to eq(['uuid:RINCON_38420BE51A3501400', 'uuid:RINCON_48A6B8FFFE4A0100']) }
  end
end
