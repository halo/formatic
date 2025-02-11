# frozen_string_literal: true

class StepperComponentPreview < ViewComponent::Preview
  class Dummy
    include ActiveModel::API

    def object
      House.new
    end

    def object_name
      :house
    end

    def label(dummy); end
  end

  def without_limitation
    render Formatic::Stepper.new(
      f: Dummy.new,
      attribute_name: :number,
      minimum: -999
    )
  end

  def minimum_minus_one
    render Formatic::Stepper.new(
      f: Dummy.new,
      attribute_name: :number,
      minimum: -1
    )
  end

  def minimum_zero
    render Formatic::Stepper.new(
      f: Dummy.new,
      attribute_name: :number,
      minimum: 0
    )
  end

  def minimum_one
    render Formatic::Stepper.new(
      f: Dummy.new,
      attribute_name: :number,
      minimum: 1
    )
  end
end
