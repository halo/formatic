# frozen_string_literal: true

# -----------------------------------------
# First, build and boot a Rails application
# -----------------------------------------

require 'view_component/engine'
class FormaticApplication < Rails::Application; end

Rails.application.routes.draw do
  resource :home
end

# I18n.load_path += Dir[Rails.root.join('config/locales/*.yml')]

require 'action_controller'
class ApplicationController < ActionController::Base; end

# The `view_component` gem makes use of `ends_with?`, so we need this.
# You can remove it if the test suite still passes.
# See https://github.com/ViewComponent/view_component/pull/1905
require 'active_support/core_ext/string/starts_ends_with'

# ------------------------------------------------------
# Second, make sure the ViewComponent gem is initialized
# ------------------------------------------------------

require 'view_component/base'
require 'action_controller/test_case'
ViewComponent::Base.config.view_component_path = File.expand_path('../app/components', __dir__)

# ----------------------------------
# Third, initialize the Formatic gem
# ----------------------------------

require 'formatic/engine'
Formatic::Engine.config.to_prepare_blocks.each(&:call)

# ----------------------------------------------
# Now we can load whatever we need for our tests
# ----------------------------------------------

require 'view_component/test_helpers'
require 'view_component/test_case'
require 'active_model'
require 'action_policy'

# -----------------------------
# Now we can load this very gem
# -----------------------------

# Poor man's solution to avoiding global state during tests.
Dir.glob("#{File.expand_path('locales', __dir__)}/*.yml").each do |path|
  I18n.load_path << path
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'formatic'

require 'minitest/autorun'
