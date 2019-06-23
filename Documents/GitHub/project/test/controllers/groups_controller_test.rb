require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
	include Devise::Test::ControllerHelpers

	def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in FactoryGirl.create(:user)
    FactoryGirl.create(:role)
  end
  # test "the truth" do
  #   assert true
  # end
end
