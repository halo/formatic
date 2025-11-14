# frozen_string_literal: true

require 'test_helper'

class DumbModel
  attr_accessor :nothing
end

class MandatoryOwnerModel
  include ActiveModel::Validations

  validates_presence_of :owner
end

class OptionalNameModel
  include ActiveModel::Validations

  attr_accessor :name
end

class TestValidators < Megatest::Test
  test 'test_required_attribute' do
    object = MandatoryOwnerModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner)

    assert_equal([:presence], validators.map(&:kind))
  end

  test 'test_required_association' do
    object = MandatoryOwnerModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner_id)

    assert_equal([:presence], validators.map(&:kind))
  end

  test 'test_optional_attribute' do
    object = OptionalNameModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner)

    assert_empty(validators)
  end

  test 'test_optional_association' do
    object = OptionalNameModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner_id)

    assert_empty(validators)
  end

  test 'test_no_validation' do
    object = DumbModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner_id)

    assert_empty(validators)
  end
end
