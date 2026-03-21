# lex-gitlab

LegionIO extension for GitLab. Provides runners for interacting with the GitLab REST API covering projects, merge requests, and pipelines.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-gitlab'
```

## Standalone Client Usage

```ruby
require 'legion/extensions/gitlab'

client = Legion::Extensions::Gitlab::Client.new(
  url: 'https://gitlab.com',
  token: 'your-private-token'
)

# Projects
client.list_projects
client.get_project(project_id: 42)
client.create_project(name: 'my-project', visibility: 'private')

# Merge Requests
client.list_merge_requests(project_id: 42)
client.get_merge_request(project_id: 42, merge_request_iid: 1)
client.create_merge_request(
  project_id: 42,
  title: 'Add new feature',
  source_branch: 'feature/my-feature',
  target_branch: 'main'
)
client.merge_merge_request(project_id: 42, merge_request_iid: 1)

# Pipelines
client.list_pipelines(project_id: 42)
client.get_pipeline(project_id: 42, pipeline_id: 100)
client.create_pipeline(project_id: 42, ref: 'main')
client.retry_pipeline(project_id: 42, pipeline_id: 100)
```

## Self-hosted GitLab

```ruby
client = Legion::Extensions::Gitlab::Client.new(
  url: 'https://gitlab.example.com',
  token: 'your-private-token'
)
```

## License

MIT
