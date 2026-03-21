# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gitlab::Client do
  subject(:client) { described_class.new(token: 'test-token') }

  describe '#initialize' do
    it 'stores token in opts' do
      expect(client.opts[:token]).to eq('test-token')
    end

    it 'stores default url in opts' do
      expect(client.opts[:url]).to eq('https://gitlab.com')
    end

    it 'accepts a custom url' do
      custom = described_class.new(url: 'https://gitlab.example.com', token: 'tok')
      expect(custom.opts[:url]).to eq('https://gitlab.example.com')
    end

    it 'accepts extra options' do
      custom = described_class.new(token: 'tok', timeout: 30)
      expect(custom.opts[:timeout]).to eq(30)
    end

    it 'compacts nil values' do
      custom = described_class.new(token: nil)
      expect(custom.opts).not_to have_key(:token)
    end
  end

  describe '#connection' do
    it 'returns a Faraday::Connection' do
      expect(client.connection).to be_a(Faraday::Connection)
    end
  end
end
