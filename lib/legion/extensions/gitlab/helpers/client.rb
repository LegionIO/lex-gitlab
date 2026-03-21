# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module Gitlab
      module Helpers
        module Client
          def connection(url: 'https://gitlab.com', token: nil, **)
            Faraday.new(url: url) do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['PRIVATE-TOKEN'] = token if token
              conn.adapter Faraday.default_adapter
            end
          end
        end
      end
    end
  end
end
