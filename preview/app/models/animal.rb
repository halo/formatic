# frozen_string_literal: true

class Animal
  include ActiveModel::API
  attr_accessor :id, :name, :four_legged
end
