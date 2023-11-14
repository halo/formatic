# frozen_string_literal: true

require 'test_helper'

class ModelNamingNamespace
  class HoldingModel
    include ActiveModel::API
  end
end

class TestTranslate < ViewComponent::TestCase
  def test_highest_specificity
    I18n.with_locale(:it) do
      requirement = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :specifics
      )

      assert_equal('Highest specificity', requirement)
    end
  end

  def test_fallback_to_object_name
    I18n.with_locale(:sv) do
      requirement = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :stumbler,
        object_name: :a_custom_object_name
      )

      assert_equal('Fall back everyone', requirement)
    end
  end

  def test_fallback_to_default
    I18n.with_locale(:fr) do
      requirement = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :generalistic
      )

      assert_equal('The General', requirement)
    end
  end

  def test_fallback_to_default_with_object_name
    I18n.with_locale(:fr) do
      requirement = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :generalistic,
        object_name: :chaos_argument
      )

      assert_equal('The General', requirement)
    end
  end

  def test_nothing
    I18n.with_locale(:fr) do
      requirement = Formatic::Wrappers::Translate.call(
        prefix: 'helpers.placeholder',
        object: ModelNamingNamespace::HoldingModel.new,
        attribute_name: :doesnt_have_one
      )

      assert_nil(requirement)
    end
  end
end
