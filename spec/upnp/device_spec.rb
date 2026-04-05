require_relative '../../app/upnp/device'
require_relative '../../app/upnp/service'

describe UPnP::Device do
  let(:attributes) do
    {
      deviceType: 'urn:schemas-upnp-org:device:MediaRenderer:1',
      friendlyName: 'Bedroom - Sonos Arc Media Renderer',
      modelName: 'Sonos Arc',
      modelNumber: 'S19',
      modelDescription: 'Sonos Arc Media Renderer',
      UDN: 'uuid:RINCON_38420BE51A3501400_MR'
    }
  end
  let(:device) { described_class.new(attributes) }

  describe '#device_type' do
    subject { device.device_type }
    it { is_expected.to eq 'urn:schemas-upnp-org:device:MediaRenderer:1' }
  end

  describe '#friendly_name' do
    subject { device.friendly_name }
    it { is_expected.to eq 'Bedroom - Sonos Arc Media Renderer' }
  end

  describe '#model_name' do
    subject { device.model_name }
    it { is_expected.to eq 'Sonos Arc' }
  end

  describe '#model_number' do
    subject { device.model_number }
    it { is_expected.to eq 'S19' }
  end

  describe '#model_description' do
    subject { device.model_description }
    it { is_expected.to eq 'Sonos Arc Media Renderer' }
  end

  describe '#udn' do
    subject { device.udn }
    it { is_expected.to eq 'uuid:RINCON_38420BE51A3501400_MR' }
  end

  describe '#services' do
    subject { device.services }
    it { is_expected.to eq [] }

    context 'when provided' do
      let(:services) { [instance_double(UPnP::Service)] }
      let(:device) { described_class.new(attributes, services: services) }

      it { is_expected.to eq services }
    end
  end

  describe '#embedded_devices' do
    subject { device.embedded_devices }
    it { is_expected.to eq [] }

    context 'when provided' do
      let(:embedded_devices) { [instance_double(described_class)] }
      let(:device) { described_class.new(attributes, embedded_devices: embedded_devices) }

      it { is_expected.to eq embedded_devices }
    end
  end
end
