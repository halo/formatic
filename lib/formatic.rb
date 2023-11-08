# frozen_string_literal: true

require 'dry/initializer'

require_relative 'formatic/version'

require 'formatic/engine' if defined?(Rails::Engine)

module Formatic
  class Error < ::StandardError; end
  class MissingModelError < Error; end
  class SubclassNameError < Error; end
end
