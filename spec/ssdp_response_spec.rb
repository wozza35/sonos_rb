require_relative '../app/ssdp/response'

describe SSDP::Response do
  let(:raw_response) do
    "HTTP/1.1 200 OK\r\n" \
      "CACHE-CONTROL: max-age = 1800\r\n" \
      "LOCATION: http://192.168.1.10:1400/xml/device_description.xml\r\n" \
      "SERVER: Linux UPnP/1.0 Sonos/63.2-88230 (ZPS9)\r\n" \
      "ST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n" \
      "\r\n"
  end
  let(:subject) { described_class.new(raw_response) }

  it 'extracts the location' do
    expect(subject.location).to eq('http://192.168.1.10:1400/xml/device_description.xml')
  end

  it 'extracts the search target' do
    expect(subject.search_target).to eq('urn:schemas-upnp-org:device:ZonePlayer:1')
  end

  describe 'lowercase headers' do
    let(:raw_response) do
      "HTTP/1.1 200 OK\r\n" \
        "location: http://192.168.1.10:1400/xml/device_description.xml\r\n" \
        "st: urn:schemas-upnp-org:device:ZonePlayer:1\r\n" \
        "\r\n"
    end

    it 'extracts the location' do
      expect(subject.location).to eq('http://192.168.1.10:1400/xml/device_description.xml')
    end

    it 'extracts the search target' do
      expect(subject.search_target).to eq('urn:schemas-upnp-org:device:ZonePlayer:1')
    end
  end

  describe 'missing headers' do
    let(:raw_response) { "HTTP/1.1 200 OK\r\n\r\n" }

    it 'returns nil for location' do
      expect(subject.location).to be_nil
    end

    it 'returns nil for search target' do
      expect(subject.search_target).to be_nil
    end
  end
end
