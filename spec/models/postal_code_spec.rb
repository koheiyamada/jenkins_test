# coding:utf-8
require 'spec_helper'

describe PostalCode do
  before(:each) do
    zip_code = FactoryGirl.create(:zip_code)
    FactoryGirl.create(:postal_code, zip_code: zip_code)
    @postal_code = zip_code.code
  end

  describe ".search_by_postal_code" do
    it "数字のみの番号で検索できる" do
      postal_code = PostalCode.search_by_postal_code(@postal_code)
      postal_code.should be_a(PostalCode)
      postal_code.prefecture.should == "京都府"
      postal_code.city.should == "京都市中京区"
      postal_code.town.should == "少将井御旅町"
      postal_code.line1.should == "京都市中京区少将井御旅町"
    end

    it "ハイフン入りで検索できる" do
      postal_code = PostalCode.search_by_postal_code(@postal_code)
      postal_code.should be_a(PostalCode)
      postal_code.prefecture.should == "京都府"
      postal_code.city.should == "京都市中京区"
      postal_code.town.should == "少将井御旅町"
      postal_code.line1.should == "京都市中京区少将井御旅町"
    end

    it "数値で表された郵便番号で検索できる" do
      postal_code = PostalCode.search_by_postal_code(@postal_code.gsub('-', '').to_i)
      postal_code.should be_a(PostalCode)
      postal_code.prefecture.should == "京都府"
      postal_code.city.should == "京都市中京区"
      postal_code.town.should == "少将井御旅町"
      postal_code.line1.should == "京都市中京区少将井御旅町"
    end
  end
end
