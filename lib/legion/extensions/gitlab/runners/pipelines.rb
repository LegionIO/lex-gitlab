# frozen_string_literal: true

require 'legion/extensions/gitlab/helpers/client'

module Legion
  module Extensions
    module Gitlab
      module Runners
        module Pipelines
          include Legion::Extensions::Gitlab::Helpers::Client

          def list_pipelines(project_id:, per_page: 20, page: 1, **)
            params = { per_page: per_page, page: page }
            response = connection(**).get("/api/v4/projects/#{project_id}/pipelines", params)
            { result: response.body }
          end

          def get_pipeline(project_id:, pipeline_id:, **)
            response = connection(**).get("/api/v4/projects/#{project_id}/pipelines/#{pipeline_id}")
            { result: response.body }
          end

          def create_pipeline(project_id:, ref:, variables: [], **)
            payload = { ref: ref, variables: variables }
            response = connection(**).post("/api/v4/projects/#{project_id}/pipeline", payload)
            { result: response.body }
          end

          def retry_pipeline(project_id:, pipeline_id:, **)
            response = connection(**).post("/api/v4/projects/#{project_id}/pipelines/#{pipeline_id}/retry", {})
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
