#-*- encoding: utf-8 -*-#
require 'spec_helper'

describe YuchoAccountApplication do
let(:student){FactoryGirl.create(:student)}
after(:each) do
  student.destroy
end

  it "を正常に作成可能" do
    temp_yucho_account = FactoryGirl.create(:temp_yucho_account)
  	yucho_account_application = student.create_yucho_account_appilcation_with(temp_yucho_account)
  	yucho_account_application.should be_valid
  end

  it "はtemp_yucho_accountを持っている" do
    temp_yucho_account = FactoryGirl.create(:temp_yucho_account)
    yucho_account_application = student.create_yucho_account_appilcation_with(temp_yucho_account)
    yucho_account_application.temp_yucho_account.should == temp_yucho_account
  end

  context "メソッド" do
    before(:each) do
      @temp_yucho_account = FactoryGirl.create(:temp_yucho_account)
      @yucho_account_application = student.create_yucho_account_appilcation_with(@temp_yucho_account)
    end

    context "accept" do
      before(:each) do
        @yucho_account_application.accept
      end

      it "でyucho_accountにtemp_yucho_accountの中身をコピー" do
        yucho_account = student.yucho_account
        yucho_account.kigo1.should == @temp_yucho_account.kigo1
        yucho_account.kigo2.should == @temp_yucho_account.kigo2
        yucho_account.bango.should == @temp_yucho_account.bango
        yucho_account.account_holder_name.should == @temp_yucho_account.account_holder_name
        yucho_account.account_holder_name_kana.should == @temp_yucho_account.account_holder_name_kana
      end

      it "でyucho_account_applicationのstatusは'accepted'" do
        @yucho_account_application.status.should == 'accepted'
      end
    end

    context "reject" do
      before(:each) do
        @yucho_account_application.reject
      end

      it "でstatusは'rejected'" do
        @yucho_account_application.status.should == 'rejected'
      end
    end
  end
end