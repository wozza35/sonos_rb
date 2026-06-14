require "sonos_rb/cli/runner"

describe SonosRB::CLI::Runner do
  let(:unit) { described_class.new }

  describe "#start" do
    subject { unit.start }

    describe 'running commands' do
      let(:commands) { %w[help exit] }

      before { allow(Readline).to receive(:readline).and_return(*commands, nil) }

      it "executes the commands" do
        expect_any_instance_of(SonosRB::CLI::Commands::Help).to receive(:execute).with([])
        expect_any_instance_of(SonosRB::CLI::Commands::Exit).to receive(:execute).with([])
        expect { subject }.to output.to_stdout
      end
    end

    describe 'commands with arguments' do
      let(:commands) { ['volume 27', nil] }

      before do
        allow(Readline).to receive(:readline).and_return(*commands)
      end

      it 'passes the parsed arguments to the command' do
        expect_any_instance_of(SonosRB::CLI::Commands::Volume).to receive(:execute).with(['27'])
        expect { subject }.to output.to_stdout
      end
    end

    describe 'unrecognized command' do
      let(:unrecognized_command) { "foo" }

      before { allow(Readline).to receive(:readline).and_return(unrecognized_command, nil) }

      it "prints unknown command message" do
        expect { subject }.to output(include(SonosRB::CLI::Runner::UNKNOWN_COMMAND % unrecognized_command)).to_stdout
      end
    end
  end
end
