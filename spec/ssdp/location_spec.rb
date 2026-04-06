require_relative '../../app/ssdp/location'

describe SSDP::Location do
  let(:subject) { described_class.new('http://192.168.1.10:1400/xml/device_description.xml') }

  it 'returns the uri of the location' do
    expect(subject.uri).to eq(URI('http://192.168.1.10:1400/xml/device_description.xml'))
  end

  it 'returns the ip of the location' do
    expect(subject.ip).to eq('192.168.1.10')
  end

  it 'returns the port of the location' do
    expect(subject.port).to eq(1400)
  end

  it 'returns ip and port as a string' do
    expect(subject.to_s).to eq('192.168.1.10:1400')
  end
end
