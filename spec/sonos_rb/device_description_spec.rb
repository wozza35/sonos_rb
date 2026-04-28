require_relative '../../lib/sonos/device_description'
require_relative '../../lib/ssdp/location'

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
      service_names = zone_player.services.map(&:name)
      expect(service_names).to eq %w[
        AlarmClock
        MusicServices
        DeviceProperties
        SystemProperties
        ZoneGroupTopology
        GroupManagement
        HTControl
        QPlay
      ]
    end

    it 'builds each service' do
      created_services = []
      expect(Service).to receive(:build).at_least(:once).and_wrap_original do |method, **kwargs|
        method.call(**kwargs).tap { |service| created_services << service }
      end

      all_services = zone_player.services + zone_player.embedded_devices.flat_map(&:services)
      expect(all_services).to eq(created_services)
    end

    describe 'embedded devices' do
      it 'parses the embedded devices' do
        device_types = zone_player.embedded_devices.map(&:device_type)
        expect(device_types).to eq ['urn:schemas-upnp-org:device:MediaServer:1',
                                     'urn:schemas-upnp-org:device:MediaRenderer:1']
      end

      it 'parses the services of the embedded devices' do
        service_names = zone_player.embedded_devices.map { |d| d.services.map(&:name) }
        expect(service_names).to eq [
          %w[ContentDirectory ConnectionManager],
          %w[RenderingControl ConnectionManager AVTransport Queue GroupRenderingControl VirtualLineIn],
        ]
      end
    end
  end
end
