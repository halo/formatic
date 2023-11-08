# frozen_string_literal: true

require 'rails/engine'
require 'dry-initializer'

module Formatic
  # :nodoc:
  class Engine < ::Rails::Engine
    isolate_namespace Formatic

    config.to_prepare do
      # Our Formatic components are subclasses of `ViewComponent::Base`.
      # When `ViewComponent::Base` is subclassed, two things happen:
      #
      #   1. Rails routes are included into the component
      #   2. The ViewComponent configuration is accessed
      #
      # So we can only require our components, once Rails has booted
      # AND the view_component gem has been fully initialized (configured).
      #
      # That's right here and now.
      require_relative '../../app/components/formatic/application_component'
      require_relative '../../app/components/formatic/wrapper'
    end
  end
end
