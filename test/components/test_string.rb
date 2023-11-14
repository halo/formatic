# frozen_string_literal: true

require 'test_helper'

class BlueModel
  include ActiveModel::API

  attr_accessor :name
end

class RedFormBuilder
  def object
    BlueModel.new
  end

  def object_name
    nil
  end

  def label(_, **args)
    'THELABEL'
  end

  def text_field(_, **args)
    'THEFIELD'
  end
end

class TestString < ViewComponent::TestCase
  def test_value_without_object
    f = RedFormBuilder.new
    component = Formatic::String.new(f:, attribute_name: :name)
    output = render_inline(component) { 'Hello, World!' }

    assert_equal('Hello, World!', output.to_html)
  end

  # def test_value
  #   object = StoneModel.new
  #   object.name = 'Rocky'
  #   f = ::Data.define(:object).new(object:)
  #   wrapper = Formatic::String.new(f:, attribute_name: :name)

  #   assert_equal('Rocky', wrapper.value)
  # end
end
