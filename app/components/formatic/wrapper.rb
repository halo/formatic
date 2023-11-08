module Formatic
  # See also https://github.com/rails/rails/blob/main/actionview/lib/action_view/helpers/tags/base.rb
  class Wrapper < ApplicationComponent
    option :f

    option :attribute_name, type: proc(&:to_sym)
    option :prevent_submit_on_enter, default: -> { false }
    option :label_for_id, default: -> {}
    option :label, as: :show_label, default: -> { true }
    option :hint, as: :show_hint, default: -> { true }
    option :required, default: -> {}

    renders_one :input
    renders_one :hint

    def param_key
      f.object.model_name.param_key
    end

    def show_label?
      show_label != false
    end

    def show_hint?
      show_hint != false
    end

    def hint_before_input?
      show_hint == :before_input
    end

    def input_name
      "#{param_key}[#{attribute_name}]"
    end

    def value
      f.object.public_send attribute_name if f.object.respond_to?(attribute_name)
    end

    def human_attribute_name
      return unless f.object

      f.object.class.human_attribute_name(attribute_name)
    end

    def error?
      error_messages.present?
    end

    def required?
      return true if required
      return false if required == false
      return unless f.object

      immediate = f.object._validators[attribute_name].first.is_a?(::ActiveRecord::Validations::PresenceValidator)
      return immediate unless association?

      radical = f.object._validators[radical_attribute_name].first.is_a?(::ActiveRecord::Validations::PresenceValidator)
      immediate || radical
    end

    def optional?
      !required?
    end

    def placeholder
      placeholder_for_object || placeholder_for_object_name
    end

    def hint
      hint_for_object || hint_for_object_name
    end

    def toggle_on
      toggle_on_for_object || toggle_on_for_object_name
    end

    def toggle_off
      toggle_off_for_object # || toggle_off_for_object_name
    end

    def error_messages
      return unless f.object

      (f.object.errors.full_messages_for(attribute_name) +
        error_messages_on_association_id).uniq
    end

    def association?
      attribute_name.to_s.end_with?('_id')
    end

    private

    def radical_attribute_name
      attribute_name[...-3].to_sym
    end

    def error_messages_on_association_id
      return [] unless association?

      f.object.errors.full_messages_for(radical_attribute_name)
    end

    def placeholder_for_object
      return unless f.object

      # TODO: Use an Array of defaults instead `I18n.t(defaults.shift, model: model, default: ['helpers.placeholder, 'some_legacy.placeholder'])`
      #       See https://github.com/rails/rails/blob/9253d4034729b9819ad4b426df661a2b03f00787/actionview/lib/action_view/helpers/form_helper.rb#L2666-L2676
      candidate = Tags::Translator.new(f.object, f.object.model_name.i18n_key.to_s, attribute_name,
                                      scope: 'helpers.placeholder').translate

      if candidate == human_attribute_name
        candidate = Tags::Translator.new(f.object, 'default', attribute_name,
                                        scope: 'helpers.placeholder').translate
      end
      return if candidate == human_attribute_name

      candidate
    end

    def hint_for_object
      return unless f.object

      candidate = Tags::Translator.new(f.object, f.object.model_name.i18n_key.to_s, attribute_name,
                                      scope: 'helpers.hint').translate

      if candidate == human_attribute_name
        candidate = Tags::Translator.new(f.object, 'default', attribute_name,
                                        scope: 'helpers.hint').translate
      end
      return if candidate == human_attribute_name

      candidate
    end

    def toggle_off_for_object
      return unless f.object

      candidate = Tags::Translator.new(f.object, f.object.model_name.i18n_key.to_s,
                                      "#{attribute_name}_inactive", scope: 'helpers.hint').translate
      return candidate unless candidate.end_with?(' inactive')
    end

    def toggle_on_for_object
      return unless f.object

      candidate = Tags::Translator.new(f.object, f.object.model_name.i18n_key.to_s,
                          "#{attribute_name}_active", scope: 'helpers.hint').translate
      return candidate unless candidate.end_with?(' active')
    end

    def placeholder_for_object_name
      Tags::Translator.new(nil, f.object_name.to_s, attribute_name,
                          scope: 'helpers.placeholder').translate
    end

    def hint_for_object_name
      Tags::Translator.new(nil, f.object_name.to_s, attribute_name, scope: 'helpers.hint').translate
    end

    def toggle_off_for_object_name
      Rails.logger.warn { attribute_name.to_s }
      Tags::Translator.new(nil, "#{attribute_name}_inactive", attribute_name,
                          scope: 'helpers.hint').translate
    end

    def toggle_on_for_object_name
      Tags::Translator.new(nil, "#{attribute_name}_active", attribute_name,
                          scope: 'helpers.hint').translate
    end
  end
end
