# frozen_string_literal: true

require 'test_helper'

class ModelNamingNamespace
  class HoldingModel
    include ActiveModel::API
  end
end

class TestTranslate < Megatest::Test
  test 'test_highest_specificity' do
    I18n.with_locale(:it) do
      translation = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :specifics
      )

      assert_equal('Highest specificity', translation)
    end
  end

  test 'test_fallback_to_object_name' do
    I18n.with_locale(:sv) do
      translation = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :stumbler,
        object_name: :a_custom_object_name
      )

      assert_equal('Fall back everyone', translation)
    end
  end

  test 'test_fallback_to_default' do
    I18n.with_locale(:fr) do
      translation = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :generalistic
      )

      assert_equal('The General', translation)
    end
  end

  test 'test_fallback_to_default_with_object_name' do
    I18n.with_locale(:fr) do
      translation = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :generalistic,
        object_name: :chaos_argument
      )

      assert_equal('The General', translation)
    end
  end

  test 'test_nothing' do
    I18n.with_locale(:fr) do
      translation = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :doesnt_have_one
      )

      assert_nil(translation)
    end
  end
end
