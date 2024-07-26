# frozen_string_literal: true

module Formatic
  # Stylish checkbox for a boolean attribute.
  class Toggle < ::Formatic::Base
    option :checked_value, default: -> { '1' }
    option :async_submit, default: -> { false }

    # = render input_component do |input|
    #   - input.with_input

    #     .c-input-toggle-component[
    #       class="#{klass} #{'js-input-toggle-component' if async_submit}"
    #     ]
    #       = f.label attribute_name, nil, { for: dom_id } do |builder|
    #         - f.check_box(attribute_name, { id: dom_id }, checked_value) + \
    #           content_tag(:i) + \
    #           content_tag(:div, input.human_attribute_name, class: 'c-input-toggle-component__label-caption-dummy') + \
    #           content_tag(:div, input.toggle_on, class: 'is-active') + \
    #           content_tag(:div, input.toggle_off, class: 'is-inactive')

    erb_template <<~ERB
      <%= render wrapper do |input| %>

        <% input.with_input do %>
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
                f.check_box(attribute_name, { id: dom_id }, checked_value) +
                  content_tag(:i) +
                  content_tag(:div, input.human_attribute_name, class: 'c-input-toggle-component__label-caption-dummy') +
                  content_tag(:div, input.toggle_on, class: 'is-active') +
                  content_tag(:div, input.toggle_off, class: 'is-inactive')
              %>
            <% end %>
          <% end %>

          </div>
        <% end %>
      <% end %>
    ERB

    def css_classes
      %i[c-formatic-toggle__input]
    end

    # There can be multiple checkboxes with the same attribute name on the page.
    # To couple a <label> to its checkbox, make the checkbox ID unequivocal.
    def dom_id
      # For predictability in tests, maybe use something like `Time.now.nsec`?
      @dom_id ||= SecureRandom.hex(4)
    end
  end
end