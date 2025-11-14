# frozen_string_literal: true

require 'test_helper'

class ManModel
  include ActiveModel::API

  attr_reader :mouse, :mouse_id

  def mouse=(record)
    @mouse = record
    @mouse_id = record.id
  end

  # Mocking ActiveRecord
  def self.reflect_on_all_associations(*)
    [Data.define(:foreign_key, :name).new('mouse_id', :mouse)]
  end
end

class MouseModel
  include ActiveModel::API

  attr_accessor :id, :name

  def presenters
    Data.define(:for_select).new([@name, @id])
  end
end

module Formatic
  class SelectTest < ApplicationTest
    test 'test_current_choice_name_with_match' do
      f = TestFormBuilder.for(ManModel.new(mouse: MouseModel.new(id: 2, name: 'Beta')))
      records = [MouseModel.new(id: 1, name: 'Alpha'), MouseModel.new(id: 2, name: 'Beta')]
      component = Formatic::Select.new(f:, attribute_name: :mouse_id, records:)

      assert_equal 'Beta', component.current_choice_name
    end

    test 'test_current_choice_name_without_match' do
      f = TestFormBuilder.for(ManModel.new(mouse: MouseModel.new(id: 99, name: 'Outlaw')))
      records = [MouseModel.new(id: 1, name: 'Alpha'), MouseModel.new(id: 2, name: 'Beta')]
      component = Formatic::Select.new(f:, attribute_name: :mouse_id, records:,
                                       include_current: true)

      assert_equal 'Outlaw', component.current_choice_name
    end
  end
end
