require_relative '../../app/sonos/device_description'
require_relative '../../app/ssdp/location'

describe Sonos::DeviceDescription do
  let(:location) { SSDP::Location.new('http://192.168.1.10:1400/xml/device_description.xml') }
  let(:unit) { described_class.new(location) }

  describe '#fetch' do
    let(:fixture) { File.read(File.expand_path('../fixtures/device_description.xml', __dir__)) }

    subject(:zone_player) { unit.fetch }

    before do
      allow(Net::HTTP).to receive(:get).with(location.uri).and_return(fixture)
    end

    it 'returns a ZonePlayer' do
      expect(zone_player).to be_a(Sonos::ZonePlayer)
    end

    it 'parses the zone player attributes' do
      expect(zone_player.room_name).to eq('Bedroom')
      expect(zone_player.display_name).to eq('Arc')
      expect(zone_player.model_name).to eq('Sonos Arc')
      expect(zone_player.model_number).to eq('S19')
      expect(zone_player.software_version).to eq('94.1-75110')
      expect(zone_player.hardware_version).to eq('1.27.1.12-2.2')
      expect(zone_player.serial_number).to eq('38-42-0M-E8-6A-35:D')
      expect(zone_player.mac_address).to eq('38:42:0B:E5:1A:35')
      expect(zone_player.zone_type).to eq('21')
    end

    it 'parses the services' do
      service_types = zone_player.services.map(&:service_type)
      expect(service_types).to eq [
        'urn:schemas-upnp-org:service:AlarmClock:1',
        'urn:schemas-upnp-org:service:MusicServices:1',
        'urn:schemas-upnp-org:service:DeviceProperties:1',
        'urn:schemas-upnp-org:service:SystemProperties:1',
        'urn:schemas-upnp-org:service:ZoneGroupTopology:1',
        'urn:schemas-upnp-org:service:GroupManagement:1',
        'urn:schemas-upnp-org:service:HTControl:1',
        'urn:schemas-tencent-com:service:QPlay:1',
      ]
    end

    it 'parses the embedded devices' do
      device_types = zone_player.embedded_devices.map(&:device_type)
      expect(device_types).to eq [
        'urn:schemas-upnp-org:device:MediaServer:1',
        'urn:schemas-upnp-org:device:MediaRenderer:1',
      ]
    end

    it 'parses media server services' do
      media_server = zone_player.embedded_devices.first
      service_types = media_server.services.map(&:service_type)
      expect(service_types).to eq [
        'urn:schemas-upnp-org:service:ContentDirectory:1',
        'urn:schemas-upnp-org:service:ConnectionManager:1',
      ]
    end

    it 'parses media renderer services' do
      media_renderer = zone_player.embedded_devices.last
      service_types = media_renderer.services.map(&:service_type)
      expect(service_types).to eq [
        'urn:schemas-upnp-org:service:RenderingControl:1',
        'urn:schemas-upnp-org:service:ConnectionManager:1',
        'urn:schemas-upnp-org:service:AVTransport:1',
        'urn:schemas-sonos-com:service:Queue:1',
        'urn:schemas-upnp-org:service:GroupRenderingControl:1',
        'urn:schemas-upnp-org:service:VirtualLineIn:1',
      ]
    end
  end
end
