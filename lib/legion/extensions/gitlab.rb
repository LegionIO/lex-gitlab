# frozen_string_literal: true

require 'legion/extensions/gitlab/version'
require 'legion/extensions/gitlab/helpers/client'
require 'legion/extensions/gitlab/runners/projects'
require 'legion/extensions/gitlab/runners/merge_requests'
require 'legion/extensions/gitlab/runners/pipelines'
require 'legion/extensions/gitlab/client'

module Legion
  module Extensions
    module Gitlab
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
