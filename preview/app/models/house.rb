# frozen_string_literal: true

class House
  include ActiveModel::API
  attr_accessor :id, :floors, :created_at
end
