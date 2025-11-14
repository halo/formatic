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

class TestWrapper < ApplicationTest
  # test 'test_value_without_object' do
  #   f = ::Data.define(:object).new(object: nil)
  #   wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

  #   assert_nil(wrapper.value)
  # end

  # test 'test_value' do
  #   object = StoneModel.new
  #   object.name = 'Rocky'
  #   f = ::Data.define(:object).new(object:)
  #   wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

  #   assert_equal('Rocky', wrapper.value)
  # end

  # test 'test_param_key' do
  #   object = RocketModel.new
  #   f = ::Data.define(:object).new(object:)
  #   wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

  #   assert_equal('rocket_model', wrapper.param_key)
  # end

  # test 'test_input_name' do
  #   object = RocketModel.new
  #   f = ::Data.define(:object).new(object:)
  #   wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

  #   assert_equal('rocket_model[name]', wrapper.input_name)
  # end

  test 'test_placeholder' do
    I18n.with_locale(:es) do
      object = RocketModel.new
      object_name = :the_rocket
      f = ::Data.define(:object, :object_name).new(object:, object_name:)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

      assert_equal('El Rocket', wrapper.placeholder)
    end
  end

  test 'test_hint_from_i18n' do
    I18n.with_locale(:es) do
      object = RocketModel.new
      f = ::Data.define(:object, :object_name).new(object:, object_name: nil)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

      assert_equal('El Hint', wrapper.hint)
    end
  end

  test 'test_manual_hint' do
    I18n.with_locale(:es) do
      object = RocketModel.new
      f = ::Data.define(:object, :object_name).new(object:, object_name: nil)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name, hint: 'Totally custom')

      assert_equal('Totally custom', wrapper.hint)
    end
  end

  test 'test_toggle_on' do
    I18n.with_locale(:es) do
      object = RocketModel.new
      f = ::Data.define(:object, :object_name).new(object:, object_name: nil)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

      assert_equal('El On', wrapper.toggle_on)
    end
  end

  test 'test_toggle_off' do
    I18n.with_locale(:es) do
      object = RocketModel.new
      f = ::Data.define(:object, :object_name).new(object:, object_name: nil)
      wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

      assert_equal('El Off', wrapper.toggle_off)
    end
  end

  test 'test_error_messages_without_errors' do
    object = RocketModel.new

    assert_predicate(object, :valid?)

    f = ::Data.define(:object).new(object:)
    wrapper = Formatic::Wrapper.new(f:, attribute_name: :name)

    assert_empty(wrapper.error_messages)
  end

  test 'test_error_messages_with_errors' do
    object = MandatoryHouseModel.new

    refute(object.valid?)
    f = ::Data.define(:object).new(object:)
    wrapper = Formatic::Wrapper.new(f:, attribute_name: :house)

    assert_equal(["House can't be blank", 'House is too short (minimum is 3 characters)'],
                 wrapper.error_messages)
  end

  test 'test_overriding_required' do
    object = MandatoryOwnerModel.new
    f = ::Data.define(:object).new(object:)

    wrapper = Formatic::Wrapper.new(f:, attribute_name: :owner)

    assert_predicate(wrapper, :required?)

    wrapper = Formatic::Wrapper.new(f:, attribute_name: :owner, required: false)

    refute_predicate(wrapper, :required?)
  end

  test 'test_overriding_optional' do
    object = OptionalTreeModel.new
    f = ::Data.define(:object).new(object:)
    wrapper = Formatic::Wrapper.new(f:, attribute_name: :tree)

    refute_predicate(wrapper, :required?)

    wrapper = Formatic::Wrapper.new(f:, attribute_name: :tree, required: true)

    assert_predicate(wrapper, :required?)
  end
end
