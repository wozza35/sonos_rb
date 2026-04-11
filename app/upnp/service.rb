module UPnP
  class Service
    def initialize(attributes)
      @service_type = attributes[:serviceType]
      @control_url = attributes[:controlURL]
    end

    def name
      service_type.split(':')[-2]
    end

    private

    attr_reader :service_type, :control_url
  end
end
