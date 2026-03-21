# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gitlab::Runners::Projects do
  let(:client) { Legion::Extensions::Gitlab::Client.new(url: 'https://gitlab.com', token: 'test-token') }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:test_connection) do
    Faraday.new(url: 'https://gitlab.com') do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter :test, stubs
    end
  end

  before { allow(client).to receive(:connection).and_return(test_connection) }

  describe '#list_projects' do
    it 'returns a list of projects' do
      stubs.get('/api/v4/projects') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'id' => 1, 'name' => 'my-project' }]]
      end
      result = client.list_projects
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['name']).to eq('my-project')
    end

    it 'passes per_page and page parameters' do
      stubs.get('/api/v4/projects') do
        [200, { 'Content-Type' => 'application/json' }, []]
      end
      result = client.list_projects(per_page: 5, page: 2)
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#get_project' do
    it 'returns a single project' do
      stubs.get('/api/v4/projects/42') do
        [200, { 'Content-Type' => 'application/json' }, { 'id' => 42, 'name' => 'my-project' }]
      end
      result = client.get_project(project_id: 42)
      expect(result[:result]['id']).to eq(42)
      expect(result[:result]['name']).to eq('my-project')
    end
  end

  describe '#create_project' do
    it 'creates a new project' do
      stubs.post('/api/v4/projects') do
        [201, { 'Content-Type' => 'application/json' }, { 'id' => 99, 'name' => 'new-project' }]
      end
      result = client.create_project(name: 'new-project')
      expect(result[:result]['name']).to eq('new-project')
    end

    it 'includes optional description and visibility' do
      stubs.post('/api/v4/projects') do
        [201, { 'Content-Type' => 'application/json' }, { 'id' => 100, 'name' => 'pub', 'visibility' => 'public' }]
      end
      result = client.create_project(name: 'pub', description: 'A public project', visibility: 'public')
      expect(result[:result]['visibility']).to eq('public')
    end
  end
end
