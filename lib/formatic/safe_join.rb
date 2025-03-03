# frozen_string_literal: true

module Formatic
  # Joins multiple html safe strings, retaining html safety.
  class SafeJoin
    include ::ActionView::Helpers::OutputSafetyHelper

    def self.call(...)
      new(...).call
    end

    def initialize(*input)
      @input = input
    end

    def call
      safe_join(@input)
    end
  end
end
