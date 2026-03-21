# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/projects'
require_relative 'runners/merge_requests'
require_relative 'runners/pipelines'

module Legion
  module Extensions
    module Gitlab
      class Client
        include Helpers::Client
        include Runners::Projects
        include Runners::MergeRequests
        include Runners::Pipelines

        attr_reader :opts

        def initialize(url: 'https://gitlab.com', token: nil, **extra)
          @opts = { url: url, token: token, **extra }.compact
        end

        def connection(**override)
          super(**@opts, **override)
        end
      end
    end
  end
end
