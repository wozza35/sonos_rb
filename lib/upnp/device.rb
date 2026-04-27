module UPnP
  class Device
    attr_reader :services, :embedded_devices

    def initialize(attributes, services: [], embedded_devices: [])
      @attributes = attributes
      @services = services
      @embedded_devices = embedded_devices
    end

    def device_type
      attributes[:deviceType]
    end

    def friendly_name
      attributes[:friendlyName]
    end

    def model_name
      attributes[:modelName]
    end

    def model_number
      attributes[:modelNumber]
    end

    def model_description
      attributes[:modelDescription]
    end

    def udn
      attributes[:UDN]
    end

    private

    attr_reader :attributes
  end
end
