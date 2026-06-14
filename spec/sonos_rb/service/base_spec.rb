require "sonos_rb/service/base"

describe SonosRB::Service::Base do
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
    let(:soap_request) { instance_double(SonosRB::SOAP::Request, perform: response) }
    let(:control_uri) { URI('http://192.168.0.182:1400/MediaRenderer/AVTransport/Control') }

    subject { service.call(action) }

    context 'without args' do
      before do
        allow(SonosRB::SOAP::Request).to receive(:new)
          .with(control_uri, action, attributes[:serviceType], {})
          .and_return(soap_request)
      end

      it 'performs a SOAP request and returns the XML document' do
        expect(subject).to be_a(REXML::Document)
        expect(subject.to_s).to eq('<xml/>')
      end
    end

    context 'with args' do
      let(:args) { { 'InstanceID' => 0, 'Channel' => 'Master' } }

      before do
        allow(SonosRB::SOAP::Request).to receive(:new)
          .with(control_uri, action, attributes[:serviceType], args)
          .and_return(soap_request)
      end

      subject { service.call(action, args) }

      it 'passes args to the SOAP request' do
        expect(subject).to be_a(REXML::Document)
        expect(subject.to_s).to eq('<xml/>')
      end
    end
  end
end
