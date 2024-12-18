# frozen_string_literal: true

module Formatic
  # Text input for one-liners.
  class String < ::Formatic::Base
    option :terminal, default: -> { false }

    erb_template <<~ERB
      <%= render wrapper do |wrap| -%>

        <% wrap.with_input do -%>
          <div class="c-formatic-string s-formatic">

          <% if readonly -%>
            <div class="s-markdown">
              <p>
                <% if terminal? -%>
                  <tt><%= value -%></tt>
                <% else -%>
                  <%= value -%>
                <% end -%>
              </p>
            </div>
          <% else -%>
            <%= f.text_field(attribute_name, **input_options) -%>
          <% end -%>

          </div>
        <% end -%>
      <% end -%>
    ERB

    def input_options
      result = {
        placeholder: wrapper.placeholder,
        autofocus:,
        class: css_classes
      }

      (result[:value] = value) if value

      result
    end

    def css_classes
      classes = %i[c-formatic-string__input]
      classes.push(:'is-terminal') if terminal?
      classes
    end

    private

    def terminal?
      !!@terminal
    end
  end
end
