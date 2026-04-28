require 'rexml/document'
require_relative '../../lib/xml/element_parser'

describe XML::ElementParser do
  it 'returns text children as a hash' do
    xml = REXML::Document.new(<<~XML).root
      <service>
        <serviceType>urn:schemas-upnp-org:service:AVTransport:1</serviceType>
        <serviceId>urn:upnp-org:serviceId:AVTransport</serviceId>
        <controlURL>/MediaRenderer/AVTransport/Control</controlURL>
      </service>
    XML

    result = described_class.parse(xml)
    expect(result).to eq(
      serviceType: 'urn:schemas-upnp-org:service:AVTransport:1',
      serviceId: 'urn:upnp-org:serviceId:AVTransport',
      controlURL: '/MediaRenderer/AVTransport/Control'
    )
  end

  it 'skips elements that have child elements' do
    xml = REXML::Document.new(<<~XML).root
      <device>
        <friendlyName>Sonos Arc</friendlyName>
        <serviceList>
          <service><serviceType>foo</serviceType></service>
        </serviceList>
      </device>
    XML

    result = described_class.parse(xml)
    expect(result).to eq(friendlyName: 'Sonos Arc')
  end
end
