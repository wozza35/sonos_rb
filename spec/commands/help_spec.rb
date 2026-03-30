require_relative "../../app/cli"

describe Commands::Help do
  describe ".command_name" do
    subject { described_class.command_name }
    it { is_expected.to eq "help" }
  end

  describe ".help" do
    subject { described_class.help }

    it 'returns a help message' do
      expect(subject).to be_a(String)
      expect(subject.length).to be > 0
    end
  end

  describe "#execute" do
    let(:unit) { described_class.new }

    subject { unit.execute }

    it "lists all available commands" do
      expect { subject }.to output(
        CLI::COMMANDS.map { |cmd| "  #{cmd.command_name} - #{cmd.help}\n" }.join
      ).to_stdout
    end
  end
end
