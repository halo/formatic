# frozen_string_literal: true

require 'test_helper'

class DogModel
  include ActiveModel::API

  attr_reader :friend, :friend_id

  def friend=(record)
    @friend = record
    @friend_id = record.id
  end

  # Mocking ActiveRecord
  def self.reflect_on_all_associations(*)
    [Data.define(:foreign_key, :name).new('friend_id', :friend)]
  end
end

class CatModel
  include ActiveModel::API

  attr_reader :id

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def ==(other)
    id == other.id
  end

  def presenters
    Data.define(:for_select).new([@name, @id])
  end
end

module Formatic
  module Selects
    class TestChoices < Minitest::Test
      def test_with_blank
        f = TestFormBuilder.for(DogModel.new)
        choices = Choices.send(:new, f:, attribute_name: :test, include_blank: true).call

        assert_equal [[nil, nil]], choices
      end

      def test_without_blank
        f = TestFormBuilder.for(DogModel.new)
        choices = Choices.send(:new, f:, attribute_name: :test).call

        assert_empty choices
      end

      def test_country_code
        f = TestFormBuilder.for(DogModel.new)
        choices = Choices.send(:new, f:, attribute_name: :attribute_akin_to_country_code).call

        assert_equal %w[Andorra AD], choices.first
        assert_equal %w[Zimbabwe ZW], choices.last
      end

      def test_keys
        I18n.with_locale(:nl) do
          f = TestFormBuilder.for(DogModel.new)
          keys = %i[first_key second_key unknown_key]
          choices = Choices.send(:new, f:, attribute_name: :name, keys:).call

          assert_equal [['The Dog', 'first_key'], ['Jimmy', 'second_key'], [nil, 'unknown_key']],
                       choices
        end
      end

      def test_associated_record_without_choices_without_current
        record = DogModel.new
        record.friend = CatModel.new(id: 42, name: 'Jack')

        f = TestFormBuilder.for(record)
        choices = Choices.send(:new, f:, attribute_name: :friend_id).call

        assert_empty choices
      end

      def test_associated_record_without_choices_with_current
        record = DogModel.new
        record.friend = CatModel.new(id: 42, name: 'Jack')

        f = TestFormBuilder.for(record)
        choices = Choices.send(:new, f:, attribute_name: :friend_id, include_current: true).call

        assert_equal [['Jack', 42]], choices
      end

      def test_associated_record_with_additional_choices_without_current
        record = DogModel.new
        record.friend = CatModel.new(id: 42, name: 'Jack')
        records = [
          CatModel.new(id: 1, name: 'Bob'),
          CatModel.new(id: 2, name: 'Will'),
          CatModel.new(id: 3, name: 'Smith')
        ]
        f = TestFormBuilder.for(record)
        choices = Choices.send(:new, f:, attribute_name: :friend_id, records:).call

        assert_equal [['Bob', 1], ['Will', 2], ['Smith', 3]], choices
      end

      def test_associated_record_with_additional_choices_with_current
        record = DogModel.new
        record.friend = CatModel.new(id: 42, name: 'Jack')
        records = [CatModel.new(id: 1, name: 'Bob'),
                   CatModel.new(id: 2, name: 'Will'),
                   CatModel.new(id: 3, name: 'Smith')]
        f = TestFormBuilder.for(record)
        choices = Choices.send(:new, f:, attribute_name: :friend_id, records:,
                                     include_current: true).call

        assert_equal [['Jack', 42], ['Bob', 1], ['Will', 2], ['Smith', 3]], choices
      end

      def test_associated_record_with_intersecting_choices
        record = DogModel.new
        record.friend = CatModel.new(id: 2, name: 'Associated Will')
        records = [
          CatModel.new(id: 1, name: 'Bob'),
          CatModel.new(id: 2, name: 'Original Will'),
          CatModel.new(id: 3, name: 'Smith')
        ]
        f = TestFormBuilder.for(record)
        choices = Choices.send(:new, f:, attribute_name: :friend_id, records:).call

        assert_equal [['Bob', 1], ['Original Will', 2], ['Smith', 3]], choices
      end
    end
  end
end
