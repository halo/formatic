# frozen_string_literal: true

module Formatic
  # File upload
  class File < ::Formatic::Base
    option :direct_upload, default: -> { true }
    option :multiple, default: -> { false }

    erb_template <<~ERB
      <%= render wrapper do |wrap| %>

        <% wrap.with_input do %>
          <div class="c-formatic-file js-formatic-file">
            <%= f.file_field attribute_name, class: "js-formatic-file__input", direct_upload:, multiple: %>
          </div>

        <% end %>
      <% end %>
    ERB
  end
end
