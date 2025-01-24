# frozen_string_literal: true

class Animal
  include ActiveModel::API
  attr_accessor :id, :name, :four_legged

  def presenters
    Data.define(:for_select).new([@name, @id])
  end
end
