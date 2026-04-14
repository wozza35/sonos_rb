require_relative '../../app/sonos/network'

describe Sonos::Network do
  let(:coordinator_udns) { %w[uuid:RINCON_1 uuid:RINCON_3] }

  let(:zone_player_1) { instance_double(Sonos::ZonePlayer, udn: 'uuid:RINCON_1', coordinator_udns: coordinator_udns) }
  let(:zone_player_2) { instance_double(Sonos::ZonePlayer, udn: 'uuid:RINCON_2') }
  let(:zone_player_3) { instance_double(Sonos::ZonePlayer, udn: 'uuid:RINCON_3') }
  let(:zone_players) { [zone_player_1, zone_player_2, zone_player_3] }

  describe 'class methods' do
    describe '.discover' do
      let(:locations) { 3.times.map { instance_double(SSDP::Location) } }
      let(:scanner) { instance_double(SSDP::Scanner, scan: locations) }

      subject { described_class.discover }

      before do
        allow(SSDP::Scanner).to receive(:new).with(described_class::SEARCH_TARGET).and_return(scanner)
        locations.each_with_index do |loc, i|
          allow(Sonos::DeviceDescription).to receive(:new).with(loc).and_return(
            instance_double(Sonos::DeviceDescription, fetch: zone_players[i])
          )
        end
      end

      it 'returns a Network instantiated with every discovered ZonePlayer' do
        result = double
        expect(described_class).to receive(:new).with(zone_players).and_return result
        expect(subject).to be result
      end
    end
  end

  describe 'instance methods' do
    let(:network) { described_class.new(zone_players) }

    describe '#zone_players' do
      subject { network.zone_players }

      it { is_expected.to eq zone_players }
    end

    describe '#coordinators' do
      subject { network.coordinators }

      it { is_expected.to eq [zone_player_1, zone_player_3] }

      it 'memoizes the request to obtain coordinator_udns' do
        expect(zone_player_1).to receive(:coordinator_udns).once.and_return(coordinator_udns)
        2.times { network.coordinators }
      end
    end
  end
end
