# frozen_string_literal: true

module Formatic
  # Text input for one-liners.
  class Date < ::Formatic::Base
    option :terminal, default: -> { false }

    erb_template <<~ERB
      <%= render wrapper do |wrap| %>

        <% wrap.with_input do %>
          <div class="c-formatic-string s-formatic">

          <% if readonly? %>
            <div class="s-markdown">
              <p>
                <% if terminal? %>
                  <tt><%= input.value %></tt>
                <% else %>
                  <%= input.value %>
                <% end %>
              </p>
            </div>
          <% else %>
            <%= f.text_field(attribute_name, **input_options) %>
          <% end %>

          </div>
        <% end %>
      <% end %>
    ERB

    def css_classes
      classes = %i[c-formatic-string__input]
      classes.push(:'is-terminal') if terminal?
      classes
    end

    def options_for_day
      options_for_select collection_for_day, day_value
    end

    def options_for_month
      options_for_select collection_for_month, f.object.public_send(attribute_name)&.month
    end

    def options_for_year
      options_for_select collection_for_year, f.object.public_send(attribute_name)&.year
    end

    def day_attribute_name
      "#{f.object.model_name.param_key}[#{attribute_name}(3i)]"
    end

    def month_attribute_name
      "#{f.object.model_name.param_key}[#{attribute_name}(2i)]"
    end

    def year_attribute_name
      "#{f.object.model_name.param_key}[#{attribute_name}(1i)]"
    end

    def day_value
      f.object.public_send(attribute_name)&.day
    end

    def day_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_3i"
    end

    def month_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_2i"
    end

    def year_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_1i"
    end

    private

    def collection_for_day
      return (1..31) if wrapper.required?

      [nil] + (1..31).to_a
    end

    def collection_for_month
      result = (1..12).map { [l(Date.new(1, _1), format: '%B  %-m'), _1] }
      result.prepend([nil, nil]) if wrapper.optional?
      result
    end

    def collection_for_year
      result = (30.years.ago.year..10.years.from_now.year)
      return result if wrapper.required?

      result.to_a.prepend nil
    end
  end
end
