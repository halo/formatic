class HouseModel
  include ActiveModel::API
  attr_accessor :floors
end

class WowComponentPreview < ViewComponent::Preview
  def standard
    # @record = HouseModel.new
  end
end
