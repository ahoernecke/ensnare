require 'test_helper'

module Ensnare
  class ViolationControllerTest < ActionController::TestCase
    test "should get redirect" do
      get :redirect
      assert_response :success
    end
  
  end
end
