# frozen_string_literal: true

class Wink
  include ActiveModel::API
  attr_accessor :id, :name, :created_at
end
