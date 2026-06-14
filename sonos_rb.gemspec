require_relative "lib/sonos_rb/version"

Gem::Specification.new do |spec|
  spec.name = "sonos_rb"
  spec.version = SonosRB::VERSION
  spec.authors = ["James Wozniak"]
  spec.email = ["jhwozniak@gmail.com"]

  spec.summary = "A CLI tool for discovering and interacting with Sonos devices on your network."
  spec.description = "SonosRB discovers Sonos devices via SSDP and exposes a CLI for inspecting and controlling them over UPnP/SOAP."
  spec.homepage = "https://github.com/wozza35/sonos_rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir["lib/**/*.rb", "bin/*", "README.md"]
  spec.bindir = "bin"
  spec.executables = ["sonos_rb"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rexml", "~> 3.2"
  spec.add_dependency "reline", "~> 0.4"

  spec.add_development_dependency "rspec", "~> 3.13"
end
