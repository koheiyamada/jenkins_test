# encoding:utf-8
require 'spec_helper'

describe Hq::HomeController do
  before(:each) do
    sign_in :user, HqUser.first
  end

  describe "GET index" do
    it "成功する" do
      get :index
      response.should be_success
    end
  end
end
