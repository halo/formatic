# frozen_string_literal: true

module Formatic
  # Multiple checkboxes for an Array of values in one attribute.
  class Checklist < ::Formatic::Base
    # Alternative 1:
    # Raw options that are passed on to the Rails collection_check_boxes.check_box.
    option :options, optional: true

    # Alternative 2:
    # ActiveRecord records used to populate the checkbox list.
    option :records, optional: true

    # Alternative 3:
    # Keys to lookup in i18n translations.
    option :keys, optional: true

    option :include_current, optional: true

    renders_many :toggles, ::Formatic::Toggle

    # This is highjacking the CSS definitions of another component, `Formatic::Toggle`.
    # I'm not terribly pleased by this, but I think it's a good work-around.
    erb_template <<~ERB
      <%= render wrapper do |wrap| %>

        <% wrap.with_input do %>
          <div class="c-formatic-checklist s-formatic">

          <% f.collection_check_boxes(attribute_name, choices, :last, :first) do |builder| %>

            <%= content_tag :div,
                            builder.label { builder.check_box(class: manual_class) + content_tag(:i) + content_tag(:span, split_and_wrap(builder.object.first)) },
                            class: 'c-formatic-toggle' %>

          <% end %>

          </div>
        <% end %>
      <% end %>
    ERB

    def choices
      ::Formatic::Choices.call(
        f:,
        attribute_name:,
        options:,
        records:,
        keys:,
        include_current:,
        include_blank: false
      )
    end

    def split_and_wrap(string)
      parts = string.split('   ')
      return parts.first if parts.size == 1

      main_part = parts[0..-2].join('   ')
      last_part = parts.last

      ::Formatic::SafeJoin.call(main_part, '<br/>'.html_safe, content_tag(:small, last_part))
    end
  end
end
