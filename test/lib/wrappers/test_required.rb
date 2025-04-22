# frozen_string_literal: true

require 'test_helper'

class MandatoryNameModel
  include ActiveModel::Validations

  attr_accessor :name

  validates_presence_of :name
  validates_presence_of :maybe_if, if: :this
  validates_presence_of :maybe_unless, unless: :that
  validates_presence_of :maybe_on, on: :create
end

class OptionalNameModel
  include ActiveModel::Validations

  attr_accessor :name
end

class TestRequired < ViewComponent::TestCase
  def test_when_directly_required
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :name)

    assert requirement
  end

  def test_when_not_required
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :free)

    assert_not requirement
  end

  def test_when_conditonally_required_if
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :maybe_if)

    assert_not requirement
  end

  def test_when_conditonally_required_unless
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :maybe_unless)

    assert_not requirement
  end

  def test_when_conditonally_required_on
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :maybe_on)

    assert_not requirement
  end
end
