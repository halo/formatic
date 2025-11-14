# frozen_string_literal: true

require 'calls'
require 'countries'
require 'holidays'
require 'importmap-rails'
require 'dry/initializer'

require 'formatic/version'
require 'formatic/css'
require 'formatic/safe_join'
require 'formatic/templates/select'
require 'formatic/templates/wrapper'
require 'formatic/choices/countries'
require 'formatic/choices/keys'
require 'formatic/choices/records'
require 'formatic/choices'
require 'formatic/wrappers/alternative_attribute_name'
require 'formatic/wrappers/error_messages'
require 'formatic/wrappers/required'
require 'formatic/wrappers/translate'
require 'formatic/wrappers/validators'

require 'formatic/engine'

module Formatic
  class Error < ::StandardError; end
  class MissingModelError < Error; end
  class SubclassNameError < Error; end
end
