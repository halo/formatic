# frozen_string_literal: true

class SelectsController < ApplicationController
  skip_forgery_protection

  def update
    if rand < 0.5
      head :created
    else
      head :unauthorized
    end
  end
end
