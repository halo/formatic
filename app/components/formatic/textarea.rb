# frozen_string_literal: true

module Formatic
  # Text input for multi-line text.
  class Textarea < ::Formatic::Base
    erb_template <<~ERB
      <%= render wrapper do |wrap| -%>

        <% wrap.with_input do -%>
          <div class="c-formatic-textarea s-formatic">

          <% if readonly -%>
            <div class="s-markdown">
              <p>
                <%= value -%>
              </p>
            </div>
          <% else -%>
            <%= f.text_area(attribute_name, **input_options) -%>
          <% end -%>

          <%= footer -%>

          </div>
        <% end -%>
      <% end -%>
    ERB

    def input_options
      result = {
        placeholder: wrapper.placeholder,
        data:,
        autofocus:,
        class: css_classes
      }

      (result[:value] = value) if value

      result
    end

    def data
      { '1p-ignore' => true }.merge(manual_data)
    end

    def css_classes
      classes = %i[c-formatic-textarea__input js-formatic-textarea]
      classes.push(:'is-autosubmit') if async_submit
      classes
    end
  end
end
