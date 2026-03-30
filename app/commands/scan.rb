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
      devices = SSDP::Scanner.new.scan

      if devices.empty?
        puts "No devices found."
      else
        puts "Found #{devices.size} device(s):"
        devices.each { |device| puts "  #{device}" }
      end
    end
  end
end
