# frozen_string_literal: true

module Formatic
  module Templates
    # Holds the ERB template for this component.
    module Wrapper
      TEMPLATE = <<~ERB
        <div class="u-formatic-container <%= css_class %>">
          <div class="c-formatic-wrapper <%= [('is-required' if required?), ('c-formatic-wrapper--hint-before-input' if hint_before_input?)].join(' ') %>">

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
              <%= :exclamation_triangle %>
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

      private_constant :TEMPLATE

      def self.call
        TEMPLATE
      end
    end
  end
end
