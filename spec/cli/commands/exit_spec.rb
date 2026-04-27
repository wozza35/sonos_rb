require_relative "../../../lib/cli/commands/exit"

describe CLI::Commands::Exit do
  describe ".command_name" do
    subject { described_class.command_name }
    it { is_expected.to eq "exit" }
  end

  describe ".help" do
    subject { described_class.help }

    it 'returns a help message' do
      expect(subject).to be_a(String)
      expect(subject.length).to be > 0
    end
  end

  describe "#execute" do
    let(:session) { instance_double(CLI::Session) }
    let(:unit) { described_class.new(session) }

    subject { unit.execute }

    it "exits with status 0" do
      expect { subject }.to raise_error(SystemExit) { |e|
        expect(e.status).to eq(0)
      }
    end
  end
end
