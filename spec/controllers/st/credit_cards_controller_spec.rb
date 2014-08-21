# encoding: utf-8
require 'spec_helper'

describe St::CreditCardsController do
  disconnect_sunspot

  let(:parent){ FactoryGirl.create(:parent) }
  let(:student){ FactoryGirl.create(:student) }

  describe "GET 'register'" do
    context "はサインインしていない場合" do
      it "new_user_session_pathにリダイレクトされる" do
        get :register
        response.should redirect_to(new_user_session_path)
      end
    end

    context "はparentで" do
      context "サインインしている場合" do
        before(:each) do
          sign_in parent
        end

        it "new_user_session_pathにリダイレクトされる" do
          get :register
          response.should redirect_to(new_user_session_path)
        end
      end
    end

    context "はstudentで" do
      context "サインインしている場合" do
        before(:each) do
          sign_in student
        end

        it "HTTP成功ステータスが返る" do
          get :register
          response.status.should == 200
          response.body.should == ''
          response.should be_success
        end
      end
    end
  end

  describe "POST 'register'" do
    let(:date){ Date.today.next_month }

    def success_post_helper
      post :register, credit_card: {
        number: '4111111111111111',
        expire: date,
        security_code: '111',
      }
    end

    def invalid_post_helper
      post :register, credit_card: {
        number: 'invalid',
        expire: 'invalid',
        security_code: 'invalid',
      }
    end

    before(:each) do
      sign_in student
    end

    it "はフォームデータを正しくUser#credit_card_registerに渡している" do
      controller.current_user.should_receive(:credit_card_register) do |credit_card|
        credit_card[:number].should == '4111111111111111'
        credit_card[:expire].should == '%02d/%02d' % [date.month, date.year]
        credit_card[:security_code].should == '111'
      end

      success_post_helper
    end

    context "が成功した場合" do
      before(:each) do
        controller.current_user.stub(:credit_card_register).and_return(true)
      end

      it "User#has_credit_cardがtrueに設定される" do
        expect {
          success_post_helper
        }.to change{ controller.current_user.has_credit_card }.from(false).to(true)
      end

      it "registered_st_credit_card_pathにリダイレクトされる" do
        success_post_helper
        response.should redirect_to(registered_st_credit_card_path)
      end
    end

    context "がモデルのvalidateで失敗した場合" do
      it "PaymentVeritransTxnデータは追加されない" do
        expect {
          invalid_post_helper
        }.to_not change{ PaymentVeritransTxn.count }.from(0).to(1)
      end

      it "Parent#has_credit_cardはtrueにならない" do
        expect {
          invalid_post_helper
        }.to_not change{ controller.current_user.has_credit_card }.by(false)
      end
    end

    context "が決済プロセスで失敗した場合" do
      before(:each) do
        controller.current_user.stub(:credit_card_register).and_return(false)
      end

      it "faiureテンプレートがrenderされる" do
        success_post_helper
        response.should render_template(:failure)
      end
    end
  end
end
