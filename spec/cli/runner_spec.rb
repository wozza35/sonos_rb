require_relative "../../app/cli/runner"

describe CLI::Runner do
  let(:unit) { described_class.new }

  describe "#start" do
    subject { unit.start }

    describe 'running commands' do
      let(:commands) { %w[help exit] }

      before { allow(Readline).to receive(:readline).and_return(*commands, nil) }

      it "executes the commands" do
        expect_any_instance_of(CLI::Commands::Help).to receive(:execute)
        expect_any_instance_of(CLI::Commands::Exit).to receive(:execute)
        subject
      end
    end

    describe 'unrecognized command' do
      let(:unrecognized_command) { "foo" }

      before { allow(Readline).to receive(:readline).and_return(unrecognized_command, nil) }

      it "prints unknown command message" do
        expect { subject }.to output(include(CLI::Runner::UNKNOWN_COMMAND % unrecognized_command)).to_stdout
      end
    end
  end
end
