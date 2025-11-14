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

class TestRequired < ApplicationTest
  test 'test_when_directly_required' do
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :name)

    assert requirement
  end

  test 'test_when_not_required' do
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :free)

    refute requirement
  end

  test 'test_when_conditonally_required_if' do
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :maybe_if)

    refute requirement
  end

  test 'test_when_conditonally_required_unless' do
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :maybe_unless)

    refute requirement
  end

  test 'test_when_conditonally_required_on' do
    object = MandatoryNameModel.new
    requirement = Formatic::Wrappers::Required.call(manual_required: nil,
                                                    object:,
                                                    attribute_name: :maybe_on)

    refute requirement
  end
end
