# frozen_string_literal: true

require 'test_helper'

class GreenModel
  include ActiveModel::API

  attr_accessor :id, :name

  def presenters
    Data.define(:for_select).new([@name, @id])
  end
end

module Formatic
  class SelectTest < ViewComponent::TestCase
    def test_current_choice_name_with_match
      f = TestFormBuilder.for(GreenModel.new(id: 2))
      component = Formatic::Select.new(f:, attribute_name: :the_size,
                                       options: [['Alpha', 1], ['Beta', 2]])

      assert_equal 'Beta', component.current_choice_name
    end

    def test_current_choice_name_without_match
      f = TestFormBuilder.for(GreenModel.new(id: 99, name: 'Outlaw'))
      component = Formatic::Select.new(f:, attribute_name: :the_size,
                                       options: [['Alpha', 1], ['Beta', 2]])

      assert_equal 'Outlaw', component.current_choice_name
    end
  end
end
