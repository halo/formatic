# frozen_string_literal: true

require 'test_helper'

class TimeModel
  include ActiveModel::API

  attr_accessor :the_time
end

class FormaticTimeTest < ApplicationTest
  test 'custom data attributes' do
    f = TestFormBuilder.for(TimeModel.new(the_time: Time.now))
    component = Formatic::Time.new(f:, attribute_name: :the_time, data: { custom: 'value' })
    output = render_inline(component)

    inputs = output.css('select')
    assert inputs.any?, 'Expected at least one select element'

    inputs.each do |input|
      assert_equal 'value', input['data-custom']
    end
  end
end
