# frozen_string_literal: true

require 'legion/extensions/gitlab/helpers/client'

module Legion
  module Extensions
    module Gitlab
      module Runners
        module Projects
          include Legion::Extensions::Gitlab::Helpers::Client

          def list_projects(per_page: 20, page: 1, **)
            response = connection(**).get('/api/v4/projects', { per_page: per_page, page: page })
            { result: response.body }
          end

          def get_project(project_id:, **)
            response = connection(**).get("/api/v4/projects/#{project_id}")
            { result: response.body }
          end

          def create_project(name:, description: nil, visibility: 'private', **)
            payload = { name: name, description: description, visibility: visibility }.compact
            response = connection(**).post('/api/v4/projects', payload)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
