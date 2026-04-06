require_relative '../../app/upnp/service'

describe UPnP::Service do
  let(:attributes) do
    {
      serviceType: 'urn:schemas-upnp-org:service:AVTransport:1',
      serviceId: 'urn:upnp-org:serviceId:AVTransport',
      controlURL: '/MediaRenderer/AVTransport/Control',
      eventSubURL: '/MediaRenderer/AVTransport/Event',
      SCPDURL: '/xml/AVTransport1.xml',
    }
  end
  let(:service) { described_class.new(attributes) }

  describe '#service_type' do
    subject { service.service_type }
    it { is_expected.to eq 'urn:schemas-upnp-org:service:AVTransport:1' }
  end

  describe '#control_url' do
    subject { service.control_url }
    it { is_expected.to eq '/MediaRenderer/AVTransport/Control' }
  end

  describe '#name' do
    subject { service.name }
    it { is_expected.to eq 'AVTransport' }
  end
end
