class TogglesController < ApplicationController
  skip_forgery_protection

  def update
    head :created
  end

  def destroy
    head :no_content
  end
end
