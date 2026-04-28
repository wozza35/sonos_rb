describe SonosRB::CLI::Commands::Select do
  describe ".command_name" do
    subject { described_class.command_name }
    it { is_expected.to eq "select" }
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

    let(:coordinator_1) { instance_double(SonosRB::ZonePlayer, room_name: 'Bedroom', display_name: 'Arc') }
    let(:coordinator_2) { instance_double(SonosRB::ZonePlayer, room_name: 'Living Room', display_name: 'One') }
    let(:coordinators) { [coordinator_1, coordinator_2] }
    let(:network) { instance_double(SonosRB::Network, coordinators: coordinators) }

    before do
      allow(unit).to receive(:puts)
      allow(unit).to receive(:gets).and_return("1\n")
    end

    subject { unit.execute }

    context 'when the store does not have a network' do
      before { allow(SonosRB::Network).to receive(:discover).and_return network }

      it 'attempts to discover a network' do
        expect(SonosRB::Network).to receive(:discover).and_return network
        subject
      end

      it 'stores the discovered network' do
        subject
        expect(store.network).to eq network
      end
    end

    context 'when the store already has a network' do
      before { store.network = network }

      it 'does not attempt to discover a network' do
        expect(SonosRB::Network).to_not receive(:discover)
        subject
      end

      it 'lists the coordinators' do
        expect(unit).to receive(:puts).with("  1. Bedroom (Arc)").ordered
        expect(unit).to receive(:puts).with("  2. Living Room (One)").ordered
        subject
      end

      context 'when a valid selection is made' do
        before { allow(unit).to receive(:gets).and_return("2\n") }

        it 'stores the selected coordinator' do
          subject
          expect(store.selected_coordinator).to eq coordinator_2
        end

        it 'prints the selected room name' do
          expect(unit).to receive(:puts).with("Selected: Living Room")
          subject
        end
      end

      context 'when an invalid selection is made' do
        before { allow(unit).to receive(:gets).and_return("9\n") }

        it 'prints an error' do
          expect(unit).to receive(:puts).with("Invalid selection.")
          subject
        end

        it 'does not store a coordinator' do
          subject
          expect(store.selected_coordinator).to be_nil
        end
      end

      context 'when input is empty' do
        before { allow(unit).to receive(:gets).and_return("\n") }

        it 'does not store a coordinator' do
          subject
          expect(store.selected_coordinator).to be_nil
        end
      end

      context 'when there are no coordinators' do
        let(:coordinators) { [] }

        it 'prints a message' do
          expect(unit).to receive(:puts).with("No coordinators found.")
          subject
        end
      end
    end
  end
end
