# frozen_string_literal: true

require 'test_helper'

class StepperModel
  include ActiveModel::API

  attr_accessor :the_number
end

class FormaticStepperTest < ApplicationTest
  test 'custom data attributes' do
    f = TestFormBuilder.for(StepperModel.new(the_number: 5))
    component = Formatic::Stepper.new(f:, attribute_name: :the_number, data: { custom: 'value' })
    output = render_inline(component)

    input = output.at_css('.c-formatic-stepper__number')
    refute_nil input, 'Expected a stepper number input'

    assert_equal 'value', input['data-custom']
  end
end
