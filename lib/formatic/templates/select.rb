# frozen_string_literal: true

module Formatic
  module Templates
    # Holds the ERB template for this component.
    module Select
      TEMPLATE = <<~ERB
        <%= render wrapper do |wrap| %>
          <% wrap.with_input do %>
            <div class="c-formatic-select s-formatic">

              <% if readonly %>
                <div class="s-markdown">
                  <p>
                    <%= current_choice_name %>
                  </p>
                </div>
              <% else %>

                <%= f.select attribute_name, choices, {}, { class: ['c-formatic-select', 'js-formatic-select', ('is-autosubmit' if async_submit)] } %>

              <% end %>
            </div>
          <% end %>
        <% end %>
      ERB

      private_constant :TEMPLATE

      def self.call
        TEMPLATE
      end
    end
  end
end
