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

  describe '#get_volume' do
    let(:response) { REXML::Document.new('<CurrentVolume>17</CurrentVolume>') }

    it 'requests the master channel volume and returns it as an integer' do
      expect(service).to receive(:call).with(
        'GetVolume',
        { 'InstanceID' => 0, 'Channel' => 'Master' }
      ).and_return(response)

      expect(service.get_volume).to eq 17
    end
  end

  describe '#set_volume' do
    it 'sends the desired volume to the rendering control service' do
      expect(service).to receive(:call).with(
        'SetVolume',
        {
          'InstanceID' => 0,
          'Channel' => 'Master',
          'DesiredVolume' => 42,
        }
      )

      service.set_volume(42)
    end
  end
end
