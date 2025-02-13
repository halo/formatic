# frozen_string_literal: true

class Planet
  include ActiveModel::API
  attr_accessor :id, :name

  def presenters
    Data.define(:for_select).new([title, @id])
  end

  private

  def title
    "#{@name}   This is a #{%w[nice long short beautiful].sample} comment"
  end
end
