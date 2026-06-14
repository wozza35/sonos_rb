require "sonos_rb/soap/envelope"

describe SonosRB::SOAP::Envelope do
  let(:namespace) { 'urn:schemas-upnp-org:service:Example:1' }
  let(:operation) { 'TestAction' }
  let(:arguments) { {} }
  let(:envelope) { described_class.new(operation, namespace, arguments) }

  describe '#to_xml' do
    subject { envelope.to_xml }

    it 'generates the correct XML' do
      expected_xml = <<~XML
        <?xml version="1.0" encoding="utf-8"?>
        <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
          <s:Body>
            <u:TestAction xmlns:u="urn:schemas-upnp-org:service:Example:1"/>
          </s:Body>
        </s:Envelope>
      XML
      expect(subject).to eq(expected_xml)
    end
    context 'when the operation has arguments' do
      let(:arguments) { { 'InstanceID' => 0, 'Channel' => 'Master & More' } }

      it 'includes argument elements in the operation body' do
        expected_xml = <<~XML
          <?xml version="1.0" encoding="utf-8"?>
          <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <s:Body>
              <u:TestAction xmlns:u="urn:schemas-upnp-org:service:Example:1">
                <InstanceID>0</InstanceID>
                <Channel>Master &amp; More</Channel>
              </u:TestAction>
            </s:Body>
          </s:Envelope>
        XML
        expect(subject).to eq(expected_xml)
      end
    end
  end
end
