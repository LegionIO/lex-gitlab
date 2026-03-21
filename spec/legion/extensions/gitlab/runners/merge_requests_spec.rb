# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gitlab::Runners::MergeRequests do
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

  describe '#list_merge_requests' do
    it 'returns merge requests for a project' do
      stubs.get('/api/v4/projects/1/merge_requests') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'iid' => 1, 'title' => 'Fix bug' }]]
      end
      result = client.list_merge_requests(project_id: 1)
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['title']).to eq('Fix bug')
    end

    it 'accepts state filter' do
      stubs.get('/api/v4/projects/1/merge_requests') do
        [200, { 'Content-Type' => 'application/json' }, []]
      end
      result = client.list_merge_requests(project_id: 1, state: 'merged')
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#get_merge_request' do
    it 'returns a single merge request' do
      stubs.get('/api/v4/projects/1/merge_requests/5') do
        [200, { 'Content-Type' => 'application/json' }, { 'iid' => 5, 'title' => 'Add feature' }]
      end
      result = client.get_merge_request(project_id: 1, merge_request_iid: 5)
      expect(result[:result]['iid']).to eq(5)
      expect(result[:result]['title']).to eq('Add feature')
    end
  end

  describe '#create_merge_request' do
    it 'creates a merge request' do
      stubs.post('/api/v4/projects/1/merge_requests') do
        [201, { 'Content-Type' => 'application/json' }, { 'iid' => 10, 'title' => 'New feature' }]
      end
      result = client.create_merge_request(
        project_id:    1,
        title:         'New feature',
        source_branch: 'feature',
        target_branch: 'main'
      )
      expect(result[:result]['title']).to eq('New feature')
    end

    it 'includes optional description' do
      stubs.post('/api/v4/projects/1/merge_requests') do
        [201, { 'Content-Type' => 'application/json' }, { 'iid' => 11, 'description' => 'Details' }]
      end
      result = client.create_merge_request(
        project_id:    1,
        title:         'MR with desc',
        source_branch: 'feat',
        target_branch: 'main',
        description:   'Details'
      )
      expect(result[:result]['description']).to eq('Details')
    end
  end

  describe '#merge_merge_request' do
    it 'merges a merge request' do
      stubs.put('/api/v4/projects/1/merge_requests/5/merge') do
        [200, { 'Content-Type' => 'application/json' }, { 'iid' => 5, 'state' => 'merged' }]
      end
      result = client.merge_merge_request(project_id: 1, merge_request_iid: 5)
      expect(result[:result]['state']).to eq('merged')
    end

    it 'accepts optional merge commit message' do
      stubs.put('/api/v4/projects/1/merge_requests/5/merge') do
        [200, { 'Content-Type' => 'application/json' }, { 'iid' => 5, 'state' => 'merged' }]
      end
      result = client.merge_merge_request(
        project_id:           1,
        merge_request_iid:    5,
        merge_commit_message: 'Merging feature'
      )
      expect(result[:result]['state']).to eq('merged')
    end
  end
end
