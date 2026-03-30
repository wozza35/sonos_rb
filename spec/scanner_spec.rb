require_relative '../app/ssdp/scanner'

describe SSDP::Scanner do
  let(:unit) { described_class.new }

  describe '#scan' do
    let(:socket) { instance_double(UDPSocket, setsockopt: 0, send: nil, close: nil) }

    before do
      stub_const("SSDP::Scanner::TIMEOUT", 0.1)
      allow(IO).to receive(:select).and_return(nil)
      allow(UDPSocket).to receive(:new).and_return(socket)
    end

    subject { unit.scan }

    it 'opens a UDP socket with broadcast enabled and sends the search message' do
      expect(socket).to receive(:setsockopt).with(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
      expect(socket).to receive(:send).with(
        SSDP::Scanner::SEARCH_MESSAGE, 0, SSDP::Scanner::SSDP_ADDRESS, SSDP::Scanner::SSDP_PORT
      )

      subject
    end

    it 'closes the socket after scanning' do
      expect(socket).to receive(:close)
      subject
    end

    it 'returns empty when no devices respond' do
      expect(subject).to be_empty
    end

    context 'when devices respond' do
      let(:responses) { [response] }
      let(:select_returns) { responses.map { [socket] } + [nil] }
      let(:response_data) { 'HTTP/1.1 200 OK\r\nST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n' }

      before do
        allow(IO).to receive(:select).and_return(*select_returns)
        allow(socket).to receive(:recvfrom).and_return([response_data, nil])
        allow(SSDP::Response).to receive(:new).with(response_data).and_return(*responses)
      end

      context 'with a matching response' do
        let(:response) { instance_double(SSDP::Response, search_target: SSDP::Scanner::SEARCH_TARGET, location: 'http://192.168.0.182:1400/xml/device_description.xml') }

        it 'returns the location' do
          expect(subject).to eq(['http://192.168.0.182:1400/xml/device_description.xml'])
        end
      end

      context 'with multiple matching responses' do
        let(:response_one) { instance_double(SSDP::Response, search_target: SSDP::Scanner::SEARCH_TARGET, location: 'http://192.168.0.182:1400/xml/device_description.xml') }
        let(:response_two) { instance_double(SSDP::Response, search_target: SSDP::Scanner::SEARCH_TARGET, location: 'http://192.168.0.183:1400/xml/device_description.xml') }
        let(:responses) { [response_one, response_two] }

        it 'returns all locations' do
          expect(subject).to eq([
            'http://192.168.0.182:1400/xml/device_description.xml',
            'http://192.168.0.183:1400/xml/device_description.xml'
          ])
        end
      end

      context 'with a response that has no location' do
        let(:response) { instance_double(SSDP::Response, search_target: SSDP::Scanner::SEARCH_TARGET, location: nil) }

        it 'does not include it' do
          expect(subject).to be_empty
        end
      end

      context 'with a different search target' do
        let(:response) { instance_double(SSDP::Response, search_target: 'urn:schemas-upnp-org:device:MediaServer:1', location: 'http://192.168.0.50:8080/description.xml') }

        it 'does not include it' do
          expect(subject).to be_empty
        end
      end
    end

    context 'when an exception is raised' do
      before { allow(IO).to receive(:select).and_raise(StandardError) }

      it 'closes the socket' do
        expect(socket).to receive(:close)
        subject rescue nil
      end
    end
  end
end
