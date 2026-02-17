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
            <%- attachments&.each do |attachment| -%>
              <%- if attachment.present? -%>
                <%= hidden_field_tag input_name, attachment.signed_id %>
              <%- end -%>
            <%- end -%>

            <%= f.file_field attribute_name, class: "js-formatic-file__input", direct_upload:, multiple:, accept: %>
          </div>
        <% end %>
      <% end %>
    ERB

    private

    def attachments
      return if value.blank?

      # ActiveStorage::Attached::Many
      return value.attachments if value.respond_to?(:attachments)

      # ActiveStorage::Attached::One
      [value.attachment]
    end
  end
end
