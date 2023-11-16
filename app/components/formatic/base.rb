# frozen_string_literal: true

module Formatic
  # All inputs inherit from this class.
  class Base < ApplicationComponent
    option :f

    option :attribute_name, type: proc(&:to_sym)
    option :autofocus, default: -> { false }
    option :value, default: -> {}
    option :label, default: -> { true }
    option :readonly, default: -> { false }
    option :required, default: -> {}
    option :prevent_submit_on_enter, default: -> { false }
    option :label_for_id, default: -> {}
    option :class, as: :css_class, default: -> {}
    option :async_submit, default: -> { false }

    def wrapper
      @wrapper ||= ::Formatic::Wrapper.new(
        f:,
        attribute_name:,
        label:,
        required:,
        prevent_submit_on_enter:
      )
    end

    def input_options
      result = {
        placeholder: wrapper.placeholder,
        autofocus:,
        class: _css_classes
      }

      (result[:value] = value) if value

      result
    end

    def css_classes
      []
    end

    private

    def _css_classes
      Array(css_classes).join(' ')
    end

    def readonly?
      !!@readonly
    end
  end
end
