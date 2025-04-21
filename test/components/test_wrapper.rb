# frozen_string_literal: true

require 'test_helper'

class StoneModel
  attr_accessor :name
end

class RocketModel
  include ActiveModel::API

  attr_accessor :name
end

class MandatoryHouseModel
  include ActiveModel::Validations

  attr_accessor :house, :street_id

  validates_presence_of :house
  validates_length_of :house, minimum: 3
  validates_presence_of :street_id
end

class OptionalTreeModel
  include ActiveModel::Validations

  attr_accessor :tree
end

class TestWrapper < ViewComponent::TestCase
  # def test_value_without_object
  #   f = ::Data.define(:object).new(object: nil)
  #   wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

  #   assert_nil(wrapper.value)
  # end

  # def test_value
  #   object = StoneModel.new
  #   object.name = 'Rocky'
  #   f = ::Data.define(:object).new(object:)
  #   wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

  #   assert_equal('Rocky', wrapper.value)
  # end

  # def test_param_key
  #   object = RocketModel.new
  #   f = ::Data.define(:object).new(object:)
  #   wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

  #   assert_equal('rocket_model', wrapper.param_key)
  # end

  # def test_input_name
  #   object = RocketModel.new
  #   f = ::Data.define(:object).new(object:)
  #   wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

  #   assert_equal('rocket_model[name]', wrapper.input_name)
  # end

  def test_placeholder
    I18n.with_locale(:es) do
      object = RocketModel.new
      object_name = :the_rocket
      f = ::Data.define(:object, :object_name).new(object:, object_name:)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

      assert_equal('El Rocket', wrapper.placeholder)
    end
  end

  def test_hint_from_i18n
    I18n.with_locale(:es) do
      object = RocketModel.new
      f = ::Data.define(:object, :object_name).new(object:, object_name: nil)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

      assert_equal('El Hint', wrapper.hint)
    end
  end

  def test_manual_hint
    I18n.with_locale(:es) do
      object = RocketModel.new
      f = ::Data.define(:object, :object_name).new(object:, object_name: nil)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name, hint: 'Totally custom')

      assert_equal('Totally custom', wrapper.hint)
    end
  end

  def test_toggle_on
    I18n.with_locale(:es) do
      object = RocketModel.new
      f = ::Data.define(:object, :object_name).new(object:, object_name: nil)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

      assert_equal('El On', wrapper.toggle_on)
    end
  end

  def test_toggle_off
    I18n.with_locale(:es) do
      object = RocketModel.new
      f = ::Data.define(:object, :object_name).new(object:, object_name: nil)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

      assert_equal('El Off', wrapper.toggle_off)
    end
  end

  def test_error_messages_without_errors
    object = RocketModel.new

    assert_predicate(object, :valid?)

    f = ::Data.define(:object).new(object:)
    wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

    assert_empty(wrapper.error_messages)
  end

  def test_error_messages_with_errors
    object = MandatoryHouseModel.new

    assert_not(object.valid?)
    f = ::Data.define(:object).new(object:)
    wrapper = Formatic::Wrapper.new(f:, attribute_name: :house)

    assert_equal(["House can't be blank", 'House is too short (minimum is 3 characters)'],
                 wrapper.error_messages)
  end

  def test_overriding_required
    object = MandatoryOwnerModel.new
    f = ::Data.define(:object).new(object:)

    wrapper = Formatic::Wrapper.new(f:, attribute_name: :owner)

    assert_predicate(wrapper, :required?)

    wrapper = Formatic::Wrapper.new(f:, attribute_name: :owner, required: false)

    assert_not_predicate(wrapper, :required?)
  end

  def test_overriding_optional
    object = OptionalTreeModel.new
    f = ::Data.define(:object).new(object:)
    wrapper = Formatic::Wrapper.new(f:, attribute_name: :tree)

    assert_not_predicate(wrapper, :required?)

    wrapper = Formatic::Wrapper.new(f:, attribute_name: :tree, required: true)

    assert_predicate(wrapper, :required?)
  end
end
