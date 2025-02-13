# frozen_string_literal: true

module Formatic
  class Choices
    # Looks up options for a <select> in i18n.
    class Keys
      include Calls

      option :f
      option :attribute_name
      option :keys

      def call
        keys.map do |slug|
          caption = ::Formatic::Wrappers::Translate.call(
            prefix: :'helpers.options',
            object: f.object,
            attribute_name: "#{attribute_name}.#{slug}",
            object_name: f&.object_name
          )

          [caption, slug.to_s]
        end
      end
    end
  end
end
