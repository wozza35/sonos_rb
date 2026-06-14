require_relative '../base'

module SonosRB
  module Service
    class RenderingControl < Base
      class GetVolumeResponse
        def initialize(response)
          @response = response
        end

        def current_volume
          @response.elements['//CurrentVolume'].text.to_i
        end
      end
    end
  end
end
