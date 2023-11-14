# frozen_string_literal: true

module Formatic
  # Combines label, input, error and hint.
  # See also https://github.com/rails/rails/blob/main/actionview/lib/action_view/helpers/tags/base.rb
  class Wrapper < ApplicationComponent
    # Rails form builder. Usually with a model as `f.object`.
    option :f

    # The attribute of the record to be edited. E.g. `:name`.
    option :attribute_name, type: proc(&:to_sym)

    # Manually decide whether the form field is optional or not.
    option :required, as: :manual_required, default: -> {}

    # Manually decide to hide the label.
    option :label, as: :manual_label, default: -> { true }

    # Manually decide to hint the label.
    option :hint, as: :manual_hint, default: -> { true }

    option :prevent_submit_on_enter, default: -> { false }
    option :label_for_id, default: -> {}

    renders_one :input

    erb_template <<~ERB
      <div class="u-formatic-container">
        <div class="<%= [('is-required' if required?), ('c-formatic-wrapper--hint-before-input' if hint_before_input?)].join(' ') %>">

        <% if label? %>
          <div class="c-formatic-wrapper__label">
            <% if label_for_id.present? %>
              <%= f.label attribute_name, nil, for: label_for_id %>
            <% else %>
              <%= f.label attribute_name %>
            <% end %>
          </div>
        <% end %>

        <div class="c-formatic-wrapper__input">
          <%= input %>
        </div>

        <% if error? %>
          <div class="c-formatic-wrapper__error">
            <%= helpers.ensicon :exclamation_triangle %>
            <%= error_messages.to_sentence %>
            <% unless error_messages.to_sentence.end_with?('.') %>.<% end %>
          </div>
        <% end %>

        <% if hint? %>
          <div class="c-formatic-wrapper__hint">
            <%= hint %>
          </div>
        <% end %>

        <% if prevent_submit_on_enter %>
          <%= f.submit 'Dummy to prevent submit on Enter', disabled: true, class: 'c-formatic-wrapper__prevent-submit-on-enter' %>
        <% end %>
        </div>
      </div>
    ERB

    # ---------------------------
    # ActiveModel and Rails slugs
    # ---------------------------

    # Name of the URL param for this record.
    def param_key
      f.object.model_name.param_key
    end

    # Name of the URL param for this input.
    def input_name
      "#{param_key}[#{attribute_name}]"
    end

    # The current value of the attribute.
    def value
      f.object.public_send(attribute_name) if f.object.respond_to?(attribute_name)
    end

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
