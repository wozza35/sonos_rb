require 'uri'

describe SonosRB::Service do
  describe '.build' do
    let(:base_uri) { URI('http://192.168.0.182:1400') }
    let(:attributes) { {serviceType: "urn:schemas-upnp-org:service:#{service_name}:1" } }

    subject { described_class.build(attributes:, base_uri:) }

    context 'when a subclass exists' do
      let(:service_name) { 'ZoneGroupTopology' }

      it 'creates and returns an instance of the subclass' do
        service = double
        expect(SonosRB::Service::ZoneGroupTopology).to receive(:new).with(attributes:, base_uri:).and_return service
        expect(subject).to be service
      end
    end

    context 'when no subclass exists' do
      let(:service_name) { 'QPlay' }

      it 'creates and returns an instance of the Base Service' do
        service = double
        expect(SonosRB::Service::Base).to receive(:new).with(attributes:, base_uri:).and_return service
        expect(subject).to be service
      end
    end
  end
end
