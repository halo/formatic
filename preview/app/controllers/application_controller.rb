# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def index
    # See https://github.com/lookbook-hq/lookbook/issues/632
    # session[:dummy] = true
    # redirect_to lookbook_path
  end
end
