# frozen_string_literal: true

class StringsController < ApplicationController
  skip_forgery_protection

  def update
    session[:test] = 'hi'
    head :created
  end

  def destroy
    head :no_content
  end
end
