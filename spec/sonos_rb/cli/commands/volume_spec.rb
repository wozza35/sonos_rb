require "sonos_rb/cli/commands/volume"
require "sonos_rb/cli/session"

describe SonosRB::CLI::Commands::Volume do
  let(:session) { SonosRB::CLI::Session.new }
  let(:unit) { described_class.new(session) }
  let(:coordinator) { instance_double(SonosRB::ZonePlayer, volume: 30) }

  describe '#execute' do
    subject { unit.execute }

    context 'when no coordinator is selected' do
      it 'prints a message to select a coordinator' do
        expect { subject }.to output(include("No coordinator selected")).to_stdout
      end
    end

    context 'when a coordinator is selected' do
      before { session.selected_coordinator = coordinator }

      context 'when no new volume is entered' do
        before { allow(unit).to receive(:gets).and_return("\n") }

        it 'displays the current volume' do
          expect { subject }.to output(include("Current volume: 30")).to_stdout
        end

        it 'does not call set_volume' do
          expect(coordinator).not_to receive(:volume=)
          subject
        end
      end

      context 'when a valid volume is entered' do
        before { allow(unit).to receive(:gets).and_return("50\n") }

        it 'sets the volume and confirms' do
          expect(coordinator).to receive(:volume=).with(50)
          expect { subject }.to output(include("Volume set to 50")).to_stdout
        end
      end

      context 'when an invalid volume is entered' do
        before { allow(unit).to receive(:gets).and_return("150\n") }

        it 'prints an error message' do
          expect(coordinator).not_to receive(:volume=)
          expect { subject }.to output(include("Invalid volume")).to_stdout
        end
      end
    end
  end
end
