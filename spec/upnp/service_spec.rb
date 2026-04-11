require_relative '../../app/upnp/service'

describe UPnP::Service do
  let(:attributes) do
    {
      serviceType: 'urn:schemas-upnp-org:service:AVTransport:1',
      controlURL: '/MediaRenderer/AVTransport/Control',
    }
  end
  let(:service) { described_class.new(attributes) }

  describe '#name' do
    subject { service.name }
    it { is_expected.to eq 'AVTransport' }
  end
end
