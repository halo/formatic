# frozen_string_literal: true

module Formatic
  # All inputs inherit from this class.
  class Base < ApplicationComponent
    # Rails form builder. Usually with a model as `f.object`.
    option :f

    # The method that is called on the form object.
    #
    # This is uncontroversial, both Rails and SimpleForm have this.
    #  Rails:      `f.text_field(:title)`
    #  SimpleForm: `f.input(:title)`
    option :attribute_name, type: proc(&:to_sym)

    # If passed in, used as the `<input value="...">`
    # If not passed in, it is derived from the form object.
    option :value, as: :manual_value, default: -> { :_fetch_from_record }

    # CSS class(es) applied to the <input> element
    # and the wrapper <div> respectively.
    option :class, as: :manual_class, optional: true
    option :wrapper_class, optional: true

    # For inputs that support `<input autofocus=...>`
    option :autofocus, default: -> { false }

    # Some inputs (such as checkboxes and textfields)
    # can be submitted continously by submitting their <form>
    # via javascript.
    option :async_submit, default: -> { false }

    # See `Formatic::Wrapper`
    option :label, default: -> { true }
    option :hint, optional: true, default: -> { true }
    option :label_for_id, optional: true
    option :readonly, as: :readonly, default: -> { false }
    option :required, optional: true
    option :prevent_submit_on_enter, default: -> { false }

    def wrapper
      @wrapper ||= ::Formatic::Wrapper.new(
        f:,
        attribute_name:,
        label:,
        hint:,
        required:,
        prevent_submit_on_enter:,
        label_for_id:,
        class: wrapper_class
      )
    end

    def value
      return manual_value if manual_value != :_fetch_from_record

      f.object.public_send(attribute_name) if f.object.respond_to?(attribute_name)
    end

    # ---------------------------
    # ActiveModel and Rails slugs
    # ---------------------------

    # Name of the URL param for this record.
    def param_key
      f.object.model_name.param_key
    end

    # # Name of the URL param for this input.
    def input_name
      "#{param_key}[#{attribute_name}]"
    end
  end
end
