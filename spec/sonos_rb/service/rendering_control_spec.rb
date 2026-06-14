require "sonos_rb/service/rendering_control"

describe SonosRB::Service::RenderingControl do
  let(:base_uri) { URI('http://192.168.0.182:1400') }
  let(:attributes) do
    {
      serviceType: 'urn:schemas-upnp-org:service:RenderingControl:1',
      controlURL: '/MediaRenderer/RenderingControl/Control',
    }
  end
  let(:service) { described_class.new(attributes:, base_uri:) }
  let(:response) { instance_double(Net::HTTPResponse) }
  let(:soap_request) { instance_double(SonosRB::SOAP::Request, perform: response) }
  let(:control_uri) { URI('http://192.168.0.182:1400/MediaRenderer/RenderingControl/Control') }

  describe '#get_volume' do
    let(:volume_xml) do
      REXML::Document.new(<<~XML)
        <Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="urn:schemas-upnp-org:service:RenderingControl:1">
          <Body>
            <GetVolumeResponse>
              <CurrentVolume>42</CurrentVolume>
            </GetVolumeResponse>
          </Body>
        </Envelope>
      XML
    end

    before do
      allow(SonosRB::SOAP::Request).to receive(:new)
        .with(control_uri, 'GetVolume', attributes[:serviceType], { 'InstanceID' => 0, 'Channel' => 'Master' })
        .and_return(soap_request)
      allow(response).to receive(:body).and_return(volume_xml.to_s)
    end

    subject { service.get_volume }

    it 'returns a GetVolumeResponse' do
      expect(subject).to be_a(SonosRB::Service::RenderingControl::GetVolumeResponse)
    end

    describe '#current_volume' do
      subject { service.get_volume.current_volume }
      it { is_expected.to eq 42 }
    end
  end

  describe '#set_volume' do
    before do
      allow(SonosRB::SOAP::Request).to receive(:new)
        .with(control_uri, 'SetVolume', attributes[:serviceType], { 'InstanceID' => 0, 'Channel' => 'Master', 'DesiredVolume' => 50 })
        .and_return(soap_request)
      allow(response).to receive(:body).and_return('<xml/>')
    end

    subject { service.set_volume(50) }

    it 'performs the SetVolume SOAP request' do
      expect(SonosRB::SOAP::Request).to receive(:new)
        .with(control_uri, 'SetVolume', attributes[:serviceType], { 'InstanceID' => 0, 'Channel' => 'Master', 'DesiredVolume' => 50 })
        .and_return(soap_request)
      subject
    end
  end
end
