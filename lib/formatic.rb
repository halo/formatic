# frozen_string_literal: true

require 'calls'
require 'dry/initializer'

require 'formatic/version'
require 'formatic/templates/wrapper'
require 'formatic/wrappers/alternative_attribute_name'
require 'formatic/wrappers/error_messages'
require 'formatic/wrappers/required'
require 'formatic/wrappers/translate'
require 'formatic/wrappers/validators'

require 'formatic/engine' if defined?(Rails::Engine)

module Formatic
  class Error < ::StandardError; end
  class MissingModelError < Error; end
  class SubclassNameError < Error; end
end
