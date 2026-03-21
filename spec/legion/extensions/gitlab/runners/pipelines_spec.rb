# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gitlab::Runners::Pipelines do
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

  describe '#list_pipelines' do
    it 'returns pipelines for a project' do
      stubs.get('/api/v4/projects/1/pipelines') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'id' => 100, 'status' => 'success' }]]
      end
      result = client.list_pipelines(project_id: 1)
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['status']).to eq('success')
    end

    it 'accepts pagination parameters' do
      stubs.get('/api/v4/projects/1/pipelines') do
        [200, { 'Content-Type' => 'application/json' }, []]
      end
      result = client.list_pipelines(project_id: 1, per_page: 5, page: 2)
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#get_pipeline' do
    it 'returns a single pipeline' do
      stubs.get('/api/v4/projects/1/pipelines/100') do
        [200, { 'Content-Type' => 'application/json' }, { 'id' => 100, 'ref' => 'main', 'status' => 'success' }]
      end
      result = client.get_pipeline(project_id: 1, pipeline_id: 100)
      expect(result[:result]['id']).to eq(100)
      expect(result[:result]['ref']).to eq('main')
    end
  end

  describe '#create_pipeline' do
    it 'creates a new pipeline' do
      stubs.post('/api/v4/projects/1/pipeline') do
        [201, { 'Content-Type' => 'application/json' }, { 'id' => 200, 'ref' => 'main', 'status' => 'created' }]
      end
      result = client.create_pipeline(project_id: 1, ref: 'main')
      expect(result[:result]['status']).to eq('created')
      expect(result[:result]['ref']).to eq('main')
    end

    it 'accepts pipeline variables' do
      stubs.post('/api/v4/projects/1/pipeline') do
        [201, { 'Content-Type' => 'application/json' }, { 'id' => 201, 'ref' => 'main', 'status' => 'created' }]
      end
      result = client.create_pipeline(
        project_id: 1,
        ref:        'main',
        variables:  [{ key: 'ENV', value: 'production' }]
      )
      expect(result[:result]['id']).to eq(201)
    end
  end

  describe '#retry_pipeline' do
    it 'retries a pipeline' do
      stubs.post('/api/v4/projects/1/pipelines/100/retry') do
        [201, { 'Content-Type' => 'application/json' }, { 'id' => 101, 'status' => 'pending' }]
      end
      result = client.retry_pipeline(project_id: 1, pipeline_id: 100)
      expect(result[:result]['status']).to eq('pending')
    end
  end
end
