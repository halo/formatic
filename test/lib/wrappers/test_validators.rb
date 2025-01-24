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

class TestValidators < Minitest::Test
  def test_required_attribute
    object = MandatoryOwnerModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner)

    assert_equal([:presence], validators.map(&:kind))
  end

  def test_required_association
    object = MandatoryOwnerModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner_id)

    assert_equal([:presence], validators.map(&:kind))
  end

  def test_optional_attribute
    object = OptionalNameModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner)

    assert_empty(validators)
  end

  def test_optional_association
    object = OptionalNameModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner_id)

    assert_empty(validators)
  end

  def test_no_validation
    object = DumbModel.new

    validators = Formatic::Wrappers::Validators.call(object:, attribute_name: :owner_id)

    assert_empty(validators)
  end
end
