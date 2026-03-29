# lex-gitlab: GitLab Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to GitLab via the REST API. Provides runners for project management, merge requests, and pipeline operations.

**GitHub**: https://github.com/LegionIO/lex-gitlab
**License**: MIT
**Version**: 0.1.2

## Architecture

```
Legion::Extensions::Gitlab
├── Runners/
│   ├── Projects       # list_projects, get_project, create_project, update_project, delete_project
│   ├── MergeRequests  # list_merge_requests, get_merge_request, create_merge_request, merge_merge_request, close_merge_request
│   └── Pipelines      # list_pipelines, get_pipeline, create_pipeline, retry_pipeline, cancel_pipeline
├── Helpers/
│   └── Client         # Faraday connection (GitLab REST API, private token auth)
└── Client             # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/gitlab.rb` | Entry point, extension registration |
| `lib/legion/extensions/gitlab/runners/projects.rb` | Project CRUD runners |
| `lib/legion/extensions/gitlab/runners/merge_requests.rb` | Merge request runners |
| `lib/legion/extensions/gitlab/runners/pipelines.rb` | Pipeline runners |
| `lib/legion/extensions/gitlab/helpers/client.rb` | Faraday connection builder (PRIVATE-TOKEN header) |
| `lib/legion/extensions/gitlab/client.rb` | Standalone Client class |

## Authentication

GitLab uses a private token passed via the `PRIVATE-TOKEN` header. Supports both GitLab.com and self-hosted instances (configure `url:` at client construction).

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (~> 2.0) | HTTP client for GitLab REST API |

## Development

24 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
