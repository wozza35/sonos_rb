require_relative 'base'
require_relative 'rendering_control/get_volume_response'

module SonosRB
  module Service
    class RenderingControl < Base
      def get_volume
        GetVolumeResponse.new(call('GetVolume', { 'InstanceID' => 0, 'Channel' => 'Master' }))
      end

      def set_volume(level)
        call('SetVolume', { 'InstanceID' => 0, 'Channel' => 'Master', 'DesiredVolume' => level })
      end
    end
  end
end
