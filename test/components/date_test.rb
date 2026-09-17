# frozen_string_literal: true

require 'test_helper'

class DateModel
  include ActiveModel::API

  attr_accessor :the_date
end

class RequiredDateModel
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :the_date

  validates_presence_of :the_date
end

class OptionalDateModel
  include ActiveModel::API

  attr_accessor :the_date
end

class DateTest < ApplicationTest
  test '#data - with custom value - is on selects' do
    f = TestFormBuilder.for(DateModel.new(the_date: Date.new(2025, 6, 15)))
    component = Formatic::Date.new(f:, attribute_name: :the_date, data: { custom: 'value' })

    output = render_inline(component)

    inputs = output.css('select')
    assert inputs.any?, 'Expected at least one select element'

    inputs.each do |input|
      assert_equal 'value', input['data-custom']
    end
  end

  test '#calendar - by default - is 5 days before now' do
    now = Time.new(2025, 6, 15, 12, 0, 0)
    f = TestFormBuilder.for(DateModel.new)

    calendar = Formatic::Date.new(f:, attribute_name: :the_date).calendar(now:)

    assert_equal Date.new(2025, 6, 10), calendar.first.date
  end

  test '#calendar - with skip_past false - is 5 days before now' do
    now = Time.new(2025, 6, 15, 12, 0, 0)
    f = TestFormBuilder.for(DateModel.new)

    calendar = Formatic::Date.new(f:, attribute_name: :the_date, skip_past: false).calendar(now:)

    assert_equal Date.new(2025, 6, 10), calendar.first.date
  end

  test '#calendar - with skip_past true - is today' do
    now = Time.new(2025, 6, 15, 12, 0, 0)
    f = TestFormBuilder.for(DateModel.new)

    calendar = Formatic::Date.new(f:, attribute_name: :the_date, skip_past: true).calendar(now:)

    assert_equal Date.new(2025, 6, 15), calendar.first.date
  end

  test '#calendar - with skip_past true - omits yesterday' do
    now = Time.new(2025, 6, 15, 12, 0, 0)
    f = TestFormBuilder.for(DateModel.new)

    calendar = Formatic::Date.new(f:, attribute_name: :the_date, skip_past: true).calendar(now:)
    dates = calendar.map(&:date)

    refute_includes dates, Date.new(2025, 6, 14)
    assert_includes dates, Date.new(2025, 6, 15)
  end

  test '#calendar - by default - ends at end of second month' do
    now = Time.new(2025, 6, 15, 12, 0, 0)
    f = TestFormBuilder.for(DateModel.new)

    calendar = Formatic::Date.new(f:, attribute_name: :the_date).calendar(now:)

    assert_equal Date.new(2025, 8, 31), calendar.last.date
  end

  test '#calendar - with skip_past true - ends same as by default' do
    now = Time.new(2025, 6, 15, 12, 0, 0)
    f = TestFormBuilder.for(DateModel.new)

    default = Formatic::Date.new(f:, attribute_name: :the_date).calendar(now:).last.date
    skipped = Formatic::Date.new(f:, attribute_name: :the_date, skip_past: true).calendar(now:).last.date

    assert_equal default, skipped
  end

  test '#skip_past - by default - is false' do
    f = TestFormBuilder.for(DateModel.new)

    component = Formatic::Date.new(f:, attribute_name: :the_date)

    assert_equal false, component.skip_past
  end

  test '#calendar - when optional - shows clear flick' do
    f = TestFormBuilder.for(OptionalDateModel.new(the_date: nil))
    component = Formatic::Date.new(f:, attribute_name: :the_date)

    output = render_inline(component)

    assert output.at_css('.c-formatic-date__clear')
  end

  test '#calendar - when required - omits clear flick' do
    f = TestFormBuilder.for(RequiredDateModel.new(the_date: nil))
    component = Formatic::Date.new(f:, attribute_name: :the_date)

    output = render_inline(component)

    assert_nil output.at_css('.c-formatic-date__clear')
  end

  test '#calendar - when required overridden to optional - shows clear flick' do
    f = TestFormBuilder.for(RequiredDateModel.new(the_date: nil))
    component = Formatic::Date.new(f:, attribute_name: :the_date, required: false)

    output = render_inline(component)

    assert output.at_css('.c-formatic-date__clear')
  end

  test '#calendar - when optional overridden to required - omits clear flick' do
    f = TestFormBuilder.for(OptionalDateModel.new(the_date: nil))
    component = Formatic::Date.new(f:, attribute_name: :the_date, required: true)

    output = render_inline(component)

    assert_nil output.at_css('.c-formatic-date__clear')
  end

  test '#calendar - with calendar false - omits clear flick' do
    f = TestFormBuilder.for(OptionalDateModel.new(the_date: nil))
    component = Formatic::Date.new(f:, attribute_name: :the_date, calendar: false)

    output = render_inline(component)

    assert_nil output.at_css('.c-formatic-date__clear')
  end
end
