require 'spec_helper'

describe AddressesController do

  describe "GET 'search'" do
    before(:each) do
      @postal_code = FactoryGirl.create(:postal_code)
    end

    it "returns http success" do
      get 'search', postal_code:@postal_code.postal_code
      response.should be_success
    end
  end

end
