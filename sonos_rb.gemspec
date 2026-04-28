require_relative 'lib/sonos_rb/version'

Gem::Specification.new do |spec|
  spec.name = 'sonos_rb'
  spec.version = SonosRB::VERSION
  spec.authors = ['James Wozniak']
  spec.email = ['james@clickmechanic.com']

  spec.summary = 'Ruby library and CLI for controlling Sonos devices'
  spec.description = 'Discover and control Sonos zone players over the local network via UPnP/SOAP.'

  spec.required_ruby_version = '>= 3.1'

  spec.files = Dir['lib/**/*.rb', 'bin/*', 'README.md', 'LICENSE*']
  spec.bindir = 'bin'
  spec.executables = ['sonos_rb']
  spec.require_paths = ['lib']

  spec.add_dependency 'rexml', '~> 3.0'

  spec.add_development_dependency 'rspec', '~> 3.0'
end
