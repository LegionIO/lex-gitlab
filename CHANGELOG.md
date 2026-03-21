# Changelog

## [0.1.0] - 2026-03-21

### Added
- Initial release
- `Helpers::Client` Faraday connection builder with `PRIVATE-TOKEN` auth header
- `Runners::Projects` with `list_projects`, `get_project`, `create_project`
- `Runners::MergeRequests` with `list_merge_requests`, `get_merge_request`, `create_merge_request`, `merge_merge_request`
- `Runners::Pipelines` with `list_pipelines`, `get_pipeline`, `create_pipeline`, `retry_pipeline`
- Standalone `Client` class including all runner modules
