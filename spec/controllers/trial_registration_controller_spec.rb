require 'spec_helper'

describe FreeRegistrationsController do

  describe "GET 'complete'" do
    it "returns http success" do
      get 'complete'
      response.should be_success
    end
  end

end
