# frozen_string_literal: true

module Formatic
  # Stepper input for integer values.
  class Stepper < ::Formatic::Base
    option :minimum, default: -> { 0 }

    erb_template <<~ERB
      <div class="c-formatic-stepper js-formatic-stepper">
        <%= link_to '#', class: 'c-formatic-stepper__step js-formatic-stepper__decrement' do %>
          &minus;
        <% end %>
        <%= text_field_tag input_name,
                            value.to_i,
                            { \
                              min: minimum,
                              inputmode: :numeric,
                              pattern: '-?[0-9]*',
                              class: 'c-formatic-stepper__number js-formatic-stepper__number',
                              placeholder: wrapper.placeholder,
                            } %>
        <%= link_to '#', class: 'c-formatic-stepper__step js-formatic-stepper__increment' do %>
          &plus;
        <% end %>
      </div>
    ERB
  end
end
