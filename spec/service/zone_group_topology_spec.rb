require_relative '../../app/service/zone_group_topology'

describe Service::ZoneGroupTopology do
  let(:service) { described_class.allocate }
  let(:soap_response) { instance_double(REXML::Document) }
  let(:response) { instance_double(Service::ZoneGroupTopology::GetZoneGroupStateResponse) }

  describe '#get_zone_group_state' do
    subject { service.get_zone_group_state }

    before do
      allow(service).to receive(:call).with('GetZoneGroupState').and_return(soap_response)
      allow(Service::ZoneGroupTopology::GetZoneGroupStateResponse).to receive(:new).with(soap_response).and_return(response)
    end

    it { is_expected.to eq(response) }
  end
end
