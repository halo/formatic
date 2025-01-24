# frozen_string_literal: true

require 'formatic/templates/wrapper'

module Formatic
  # Combines label, input, error and hint.
  # See also https://github.com/rails/rails/blob/main/actionview/lib/action_view/helpers/tags/base.rb
  class Wrapper < ApplicationComponent
    # Passing on the form builder.
    option :f

    # This is not an actual <input>, but it's the wrapper's container div for the <input>.
    renders_one :input

    # The attribute of the record to be edited. E.g. `:name`.
    option :attribute_name, type: proc(&:to_sym)

    # Manually decide whether the form field is optional or not.
    option :required, as: :manual_required, optional: true

    # Manually decide to hide the label.
    option :label, as: :manual_label, default: -> { true }

    # Manually decide to hide the hint.
    option :hint, as: :manual_hint, default: -> { true }

    # Autocompletion + Enter should not submit the form.
    option :prevent_submit_on_enter, default: -> { false }

    # Multiple inputs can belong to one label (e.g. select day, month, year).
    # With this you can specify the ID of one first input to couple the label to it.
    option :label_for_id, optional: true

    # CSS
    option :class, as: :css_class, optional: true

    erb_template(::Formatic::Templates::Wrapper.call)

    # ---------------------------
    # ActiveModel and Rails slugs
    # ---------------------------

    # Name of the URL param for this record.
    # def param_key
    #   f.object.model_name.param_key
    # end

    # # Name of the URL param for this input.
    # def input_name
    #   "#{param_key}[#{attribute_name}]"
    # end

    # # The current value of the attribute.
    # def value
    #   f.object.public_send(attribute_name) if f.object.respond_to?(attribute_name)
    # end

    # -----------------
    # Querying of slots
    # -----------------

    # Whether to display a label or not.
    def label?
      manual_label != false
    end

    # Whether to display a hint or not.
    def hint?
      manual_hint != false
    end

    def error?
      error_messages.present?
    end

    def required?
      @required ||= ::Formatic::Wrappers::Required.call(manual_required:, object:, attribute_name:)
    end

    def optional?
      !required?
    end

    def hint_before_input?
      manual_hint == :before_input
    end

    def error_messages
      @error_messages ||= ::Formatic::Wrappers::ErrorMessages.call(
        object:,
        attribute_name:
      )
    end

    # -----------
    # Static I18n
    # -----------

    def placeholder
      @placeholder ||= ::Formatic::Wrappers::Translate.call(
        prefix: :'helpers.placeholder',
        object:,
        attribute_name:,
        object_name: f&.object_name
      )
    end

    def hint
      @hint ||= ::Formatic::Wrappers::Translate.call(
        prefix: :'helpers.hint',
        object:,
        attribute_name:,
        object_name: f&.object_name
      )
    end

    def toggle_on
      @toggle_on ||= ::Formatic::Wrappers::Translate.call(
        prefix: :'helpers.hint',
        object:,
        attribute_name: :"#{attribute_name}_active",
        object_name: f&.object_name
      )
    end

    def toggle_off
      @toggle_off ||= ::Formatic::Wrappers::Translate.call(
        prefix: :'helpers.hint',
        object:,
        attribute_name: :"#{attribute_name}_inactive",
        object_name: f&.object_name
      )
    end

    private

    def object
      f&.object
    end
  end
end
