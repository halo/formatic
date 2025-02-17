# frozen_string_literal: true

module Formatic
  # Stylish checkbox for a boolean attribute.
  class Toggle < ::Formatic::Base
    erb_template <<~ERB
      <%= render wrapper do |wrap| %>

        <% wrap.with_input do %>
          <div class="c-formatic-toggle s-formatic <%= 'js-formatic-toggle' if async_submit %>">

          <% if readonly %>
            <div class="s-markdown">
              <p>
                <%= value %>
              </p>
            </div>
          <% else %>
            <%= f.label attribute_name, nil, { for: dom_id } do |builder| %>
              <%
                f.check_box(attribute_name, { id: dom_id, class: css_classes }) +
                  content_tag(:i) +
                  content_tag(:div, human_attribute_name, class: 'c-formatic-toggle__label-caption-dummy') +
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
      ::Formatic::Css.call('c-formatic-toggle__input', manual_class)
    end

    # So that the wrapper <label> references our custom checkbox.
    def label_for_id
      dom_id
    end

    def human_attribute_name
      return unless f.object

      f.object.class.human_attribute_name(attribute_name)
    end

    # There can be multiple checkboxes with the same attribute name on the page.
    # To couple a <label> to its checkbox, make the checkbox ID unequivocal.
    def dom_id
      # For predictability in tests, maybe use something like `Time.now.nsec`?
      @dom_id ||= SecureRandom.hex(4)
    end
  end
end
