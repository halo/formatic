# frozen_string_literal: true

class TestTemplate
  include ::ActionView::Helpers::FormHelper
end

class TestFormBuilder < ActionView::Helpers::FormBuilder
  def self.for(object, options = {})
    new(nil, object, TestTemplate.new, options)
  end
end
