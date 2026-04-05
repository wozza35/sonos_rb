module UPnP
  class Service
    attr_reader :service_type, :control_url

    def initialize(attributes)
      @service_type = attributes[:serviceType]
      @control_url = attributes[:controlURL]
    end
  end
end
