require_relative 'base'

module SonosRB
  module Service
    class RenderingControl < Base
      def get_volume(channel: 'Master', instance_id: 0)
        response = call('GetVolume', { 'InstanceID' => instance_id, 'Channel' => channel })
        response.elements['//CurrentVolume'].text.to_i
      end

      def set_volume(volume, channel: 'Master', instance_id: 0)
        call(
          'SetVolume',
          {
            'InstanceID' => instance_id,
            'Channel' => channel,
            'DesiredVolume' => volume,
          }
        )
      end
    end
  end
end
