# frozen_string_literal: true

module Formatic
  # All inputs inherit from this class.
  class Base < ApplicationComponent
    # Rails form builder. Usually with a model as `f.object`.
    option :f

    # -- Both Wrapper and Input --

    # The method that is called on the form object.
    #
    # This is uncontroversial, both Rails and SimpleForm have this.
    #  Rails:      `f.text_field(:title)`
    #  SimpleForm: `f.input(:title)`
    #
    option :attribute_name, type: proc(&:to_sym)

    # -- Mostly Input --
    option :value, default: -> {}
    option :class, as: :css_class, default: -> {}
    option :autofocus, default: -> { false }

    # -- Mostly Wrapper --
    option :readonly, default: -> { false }
    option :required, default: -> {}
    option :async_submit, default: -> { false }

    # -- Only Wrapper
    option :wrapper_class, default: -> {}
    option :label, default: -> { true }
    option :prevent_submit_on_enter, default: -> { false }
    option :label_for_id, default: -> {}

    def wrapper
      @wrapper ||= ::Formatic::Wrapper.new(
        f:,
        attribute_name:,
        label:,
        required:,
        prevent_submit_on_enter:,
        label_for_id:,
        class: wrapper_class
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

    # Override in subclass.
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
