# frozen_string_literal: true

class House
  include ActiveModel::API
  attr_accessor :id, :floors, :pet, :created_at
end
