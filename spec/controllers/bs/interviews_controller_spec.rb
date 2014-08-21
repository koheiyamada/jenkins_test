require 'spec_helper'

describe Bs::InterviewsController do

  before(:each) do
    bs_user = FactoryGirl.create(:bs_user)
    sign_in bs_user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      parent = FactoryGirl.create(:parent)
      interview = FactoryGirl.create(:interview, user1:parent, user2:controller.current_user, duration: 30)

      get 'show', id:interview
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

end
