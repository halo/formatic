# frozen_string_literal: true

class WinksController < ApplicationController
  skip_forgery_protection

  def create
    session[:test] = 'hi'
    head :created
  end

end
