require_relative '../../app/sonos/zone_player'

describe Sonos::ZonePlayer do
  let(:attributes) do
    {
      deviceType: 'urn:schemas-upnp-org:device:ZonePlayer:1',
      roomName: 'Bedroom',
      displayName: 'Arc',
      softwareVersion: '94.1-75110',
      hardwareVersion: '1.27.1.12-2.2',
      serialNum: '38-42-0M-E8-6A-35:D',
      MACAddress: '38:42:0B:E5:1A:35',
      zoneType: '21'
    }
  end
  let(:zone_player) { described_class.new(attributes) }

  it 'is a UPnP::Device' do
    expect(zone_player).to be_a(UPnP::Device)
  end

  describe '#room_name' do
    subject { zone_player.room_name }
    it { is_expected.to eq 'Bedroom' }
  end

  describe '#display_name' do
    subject { zone_player.display_name }
    it { is_expected.to eq 'Arc' }
  end

  describe '#software_version' do
    subject { zone_player.software_version }
    it { is_expected.to eq '94.1-75110' }
  end

  describe '#hardware_version' do
    subject { zone_player.hardware_version }
    it { is_expected.to eq '1.27.1.12-2.2' }
  end

  describe '#serial_number' do
    subject { zone_player.serial_number }
    it { is_expected.to eq '38-42-0M-E8-6A-35:D' }
  end

  describe '#mac_address' do
    subject { zone_player.mac_address }
    it { is_expected.to eq '38:42:0B:E5:1A:35' }
  end

  describe '#zone_type' do
    subject { zone_player.zone_type }
    it { is_expected.to eq '21' }
  end
end
