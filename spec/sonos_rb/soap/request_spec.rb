describe SonosRB::SOAP::Request do
  let(:uri) { URI('http://192.168.0.182:1400/MediaRenderer/AVTransport/Control') }
  let(:operation) { 'GetTransportInfo' }
  let(:namespace) { 'urn:schemas-upnp-org:service:AVTransport:1' }
  let(:unit) { described_class.new(uri, operation, namespace) }

  describe '#perform' do
    let(:http) { instance_double(Net::HTTP) }
    let(:response) { instance_double(Net::HTTPResponse) }

    before do
      allow(Net::HTTP).to receive(:new).with(uri.hostname, uri.port).and_return(http)
    end

    subject { unit.perform }

    it 'makes an HTTP request and returns the response' do
      expected_body = SonosRB::SOAP::Envelope.new(operation, namespace).to_xml

      expect(http).to receive(:request) do |req|
        expect(req).to be_a(Net::HTTP::Post)
        expect(req.body).to eq(expected_body)
        expect(req['Content-Type']).to eq('text/xml; charset="utf-8"')
        expect(req['SOAPACTION']).to eq("\"#{namespace}##{operation}\"")
      end.and_return(response)

      expect(subject).to eq(response)
    end
  end
end
