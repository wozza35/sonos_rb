require_relative "base"
require_relative "../ssdp/scanner"

module Commands
  class Scan < Base
    def self.command_name
      "scan"
    end

    def self.help
      "Scan the network for Sonos devices"
    end

    def execute
      puts "Scanning for Sonos devices..."
      locations = SSDP::Scanner.new.scan

      if locations.empty?
        puts "No devices found."
      else
        puts "Found #{locations.size} device(s):"
        locations.each { |location| puts "  #{location}" }
      end
    end
  end
end
