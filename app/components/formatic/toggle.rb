# frozen_string_literal: true

module Formatic
  # Stylish checkbox for a boolean attribute.
  class Toggle < ::Formatic::Base
    option :checked_value, default: -> { '1' }
    option :async_submit, default: -> { false }

    erb_template <<~ERB
      <%= render wrapper do |wrap| %>

        <% wrap.with_input do %>
          <div class="c-formatic-toggle s-formatic">

          <% if readonly? %>
            <div class="s-markdown">
              <p>
                <%= input.value %>
              </p>
            </div>
          <% else %>
            <%= f.label attribute_name, nil, { for: dom_id } do |builder| %>
              <%
                f.check_box(attribute_name, { id: dom_id, class: css_classes }, checked_value) +
                  content_tag(:i) +
                  content_tag(:div, "wrap.human_attribute_name", class: 'c-formatic-toggle__label-caption-dummy') +
                  content_tag(:div, wrap.toggle_on, class: 'is-active') +
                  content_tag(:div, wrap.toggle_off, class: 'is-inactive')
              %>
            <% end %>
          <% end %>

          </div>
        <% end %>
      <% end %>
    ERB

    def css_classes
      ['c-formatic-toggle__input', css_class].flatten.compact
    end

    # There can be multiple checkboxes with the same attribute name on the page.
    # To couple a <label> to its checkbox, make the checkbox ID unequivocal.
    def dom_id
      # For predictability in tests, maybe use something like `Time.now.nsec`?
      @dom_id ||= SecureRandom.hex(4)
    end
  end
end
