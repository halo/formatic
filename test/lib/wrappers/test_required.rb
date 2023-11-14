# frozen_string_literal: true
# # frozen_string_literal: true

# require 'test_helper'

# class MandatoryNameModel
#   include ActiveModel::Validations

#   attr_accessor :name

#   validates_presence_of :name
# end

# class OptionalNameModel
#   include ActiveModel::Validations

#   attr_accessor :name
# end

# class TestRequired < ViewComponent::TestCase
#   def test_when_directly_required
#     object = MandatoryNameModel.new
#     requirement = Formatic::Wrappers::Required.call(manual_required: object:)

#     assert_nil(wrapper.value)
#   end
# end
