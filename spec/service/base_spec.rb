require_relative '../../app/service/base'

describe Service::Base do
  let(:base_uri) { URI('http://192.168.0.182:1400') }
  let(:attributes) do
    {
      serviceType: 'urn:schemas-upnp-org:service:AVTransport:1',
      controlURL: '/MediaRenderer/AVTransport/Control',
    }
  end
  let(:service) { described_class.new(attributes:, base_uri:) }

  describe '#name' do
    subject { service.name }
    it { is_expected.to eq 'AVTransport' }
  end

  describe '#call' do
    let(:action) { 'GetTransportInfo' }
    let(:response) { instance_double(Net::HTTPResponse, body: '<xml/>') }
    let(:soap_request) { instance_double(SOAP::Request, perform: response) }

    before do
      allow(SOAP::Request).to receive(:new)
                                .with(URI.join(base_uri, attributes[:controlURL]), action, attributes[:serviceType])
                                .and_return(soap_request)
    end

    subject { service.call(action) }

    it 'performs a SOAP request and returns the XML document' do
      expect(subject).to be_a(REXML::Document)
      expect(subject.to_s).to eq('<xml/>')
    end
  end
end
