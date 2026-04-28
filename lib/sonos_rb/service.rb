module Service
  autoload :Base, File.expand_path('service/base', __dir__)
  autoload :ZoneGroupTopology, File.expand_path('service/zone_group_topology', __dir__)

  def self.build(attributes:, base_uri:)
    class_name = attributes[:serviceType].split(':')[-2]
    klass = const_defined?(class_name, false) ? const_get(class_name) : Base
    klass.new(base_uri: base_uri, attributes:)
  end
end
