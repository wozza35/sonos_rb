module SonosRB
  module Service
    autoload :Base, 'sonos_rb/service/base'
    autoload :ZoneGroupTopology, 'sonos_rb/service/zone_group_topology'

    def self.build(attributes:, base_uri:)
      class_name = attributes[:serviceType].split(':')[-2]
      klass = const_defined?(class_name, false) ? const_get(class_name) : Base
      klass.new(base_uri: base_uri, attributes:)
    end
  end
end
