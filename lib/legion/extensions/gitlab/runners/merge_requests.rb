# frozen_string_literal: true

require 'legion/extensions/gitlab/helpers/client'

module Legion
  module Extensions
    module Gitlab
      module Runners
        module MergeRequests
          include Legion::Extensions::Gitlab::Helpers::Client

          def list_merge_requests(project_id:, state: 'opened', per_page: 20, page: 1, **)
            params = { state: state, per_page: per_page, page: page }
            response = connection(**).get("/api/v4/projects/#{project_id}/merge_requests", params)
            { result: response.body }
          end

          def get_merge_request(project_id:, merge_request_iid:, **)
            response = connection(**).get("/api/v4/projects/#{project_id}/merge_requests/#{merge_request_iid}")
            { result: response.body }
          end

          def create_merge_request(project_id:, title:, source_branch:, target_branch:, description: nil, **)
            payload = {
              title:         title,
              source_branch: source_branch,
              target_branch: target_branch,
              description:   description
            }.compact
            response = connection(**).post("/api/v4/projects/#{project_id}/merge_requests", payload)
            { result: response.body }
          end

          def merge_merge_request(project_id:, merge_request_iid:, merge_commit_message: nil, **)
            payload = merge_commit_message ? { merge_commit_message: merge_commit_message } : {}
            response = connection(**).put(
              "/api/v4/projects/#{project_id}/merge_requests/#{merge_request_iid}/merge", payload
            )
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
