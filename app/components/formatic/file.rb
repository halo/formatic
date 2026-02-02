# frozen_string_literal: true

module Formatic
  # File upload
  class File < ::Formatic::Base
    option :direct_upload, default: -> { true }
    option :multiple, default: -> { false }
    option :accept, default: -> {}

    erb_template <<~ERB
      <%= render wrapper do |wrap| %>

        <% wrap.with_input do %>

          <div class="c-formatic-file js-formatic-file">
            <%- if value.present? && value.attached? -%>
              <%= f.hidden_field attribute_name, value: value.signed_id %>
            <%- end -%>

            <%= f.file_field attribute_name, class: "js-formatic-file__input", direct_upload:, multiple:, accept: %>
          </div>
        <% end %>
      <% end %>
    ERB
  end
end
