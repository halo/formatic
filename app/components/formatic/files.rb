# frozen_string_literal: true

module Formatic
  # File upload
  class Files < ::Formatic::File
    option :multiple, default: -> { true }
  end
end
