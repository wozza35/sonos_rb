require "sonos_rb/cli/commands/volume"
require "sonos_rb/cli/session"

describe SonosRB::CLI::Commands::Volume do
  describe ".command_name" do
    subject { described_class.command_name }

    it { is_expected.to eq "volume" }
  end

  describe ".help" do
    subject { described_class.help }

    it 'returns a help message' do
      expect(subject).to be_a(String)
      expect(subject.length).to be > 0
    end
  end

  describe "#execute" do
    let(:store) { SonosRB::CLI::Session.new }
    let(:unit) { described_class.new(store) }
    let(:coordinator) { instance_double(SonosRB::ZonePlayer, volume: current_volume) }
    let(:current_volume) { 18 }

    before do
      allow(unit).to receive(:puts)
    end

    subject { unit.execute(args) }

    context 'when no coordinator has been selected' do
      let(:args) { [] }

      it 'prints an error' do
        expect(unit).to receive(:puts).with("No coordinator selected. Use 'select' first.")
        subject
      end
    end

    context 'when no argument is provided' do
      let(:args) { [] }

      before { store.selected_coordinator = coordinator }

      it 'prints the current volume' do
        expect(unit).to receive(:puts).with("Current volume: 18")
        subject
      end
    end

    context 'when a valid volume is provided' do
      let(:args) { ['42'] }

      before { store.selected_coordinator = coordinator }

      it 'sets the volume on the selected coordinator' do
        expect(coordinator).to receive(:volume=).with(42)
        subject
      end

      it 'prints the new volume' do
        allow(coordinator).to receive(:volume=).with(42)
        expect(unit).to receive(:puts).with("Volume set to 42")
        subject
      end
    end

    context 'when the volume is not an integer' do
      let(:args) { ['loud'] }

      before { store.selected_coordinator = coordinator }

      it 'prints an error' do
        expect(unit).to receive(:puts).with("Volume must be an integer between 0 and 100.")
        subject
      end
    end

    context 'when the volume is outside the valid range' do
      let(:args) { ['101'] }

      before { store.selected_coordinator = coordinator }

      it 'prints an error' do
        expect(unit).to receive(:puts).with("Volume must be an integer between 0 and 100.")
        subject
      end
    end

    context 'when too many arguments are provided' do
      let(:args) { %w[10 extra] }

      before { store.selected_coordinator = coordinator }

      it 'prints usage' do
        expect(unit).to receive(:puts).with("Usage: volume [0-100]")
        subject
      end
    end
  end
end
