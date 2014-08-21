# encoding:utf-8
require 'spec_helper'

describe RegistrationParentsController do

  def how_to_find
    {answer_option: 'search_engine_yahoo'}
  end

  def reason_to_enroll
    {answer_options: {'attractive_tutors' => {selected: '1'}}}
  end

  def params
    { parent: FactoryGirl.attributes_for(:parent),
      address: FactoryGirl.attributes_for(:address),
      payment_method: {type: CreditCardPayment.name},
      how_to_find: how_to_find,
      reason_to_enroll: reason_to_enroll}
  end

  describe "GET :new" do
    context "メール認証が完了している" do
      it "new テンプレートを描画する" do
        session[:confirmation_token] = "hoge"
        form = mock_model(ParentRegistrationForm).as_null_object
        form.stub(:blank?).and_return(false)
        form.stub(:parent).and_return(nil)
        ParentRegistrationForm.stub(:find_by_confirmation_token).and_return(form)

        ParentRegistrationForm.should_receive(:find_by_confirmation_token)
        get :new
        response.should render_template("new")
      end
    end

    context "メール認証を経ていない" do
      it "登録ページにリダイレクトする" do
        get :new
        response.should redirect_to('/confirmation1')
      end
    end
  end

  describe "POST :create" do
    context "ユーザがメール認証を完了している場合" do
      let(:parent_registration_form) {mock_model(ParentRegistrationForm).as_null_object}

      before(:each) do
        ParentRegistrationForm.stub(:find_by_confirmation_token).and_return(parent_registration_form)
        session[:confirmation_token] = "hoge"
        @parent_attrs = FactoryGirl.attributes_for(:parent)
        parent_registration_form.stub(:email).and_return("shimokawa@soba-project.com")
        parent_registration_form.stub(:upload_speed){nil}
        parent_registration_form.stub(:download_speed){nil}
        parent_registration_form.stub(:os_id){1}
        parent_registration_form.stub(:adsl){false}
        parent_registration_form.stub(:windows_experience_index_score){nil}
      end

      it "find_by_confirmation_tokenでParentRegistrationFormオブジェクトをロードする" do
        ParentRegistrationForm.should_receive(:find_by_confirmation_token)
        post :create, params
      end

      it "@parent_registration_form にオブジェクトを割り当てる" do
        post :create, params
        assigns(:parent_registration_form).should be_a(ParentRegistrationForm)
      end

      it "Parent オブジェクトを作成する" do
        parent = mock_model(Parent).as_null_object
        Parent.should_receive(:new).and_return(parent)
        controller.should_receive(:sign_in)

        post :create, params
      end

      it "@parent_registration_formは新しく作成したParentオブジェクトに関連付けられる" do
        post :create, params
        assigns(:parent_registration_form).user.should be_present
      end

      it "登録完了ページにリダイレクトする" do
        post :create, params
        response.should redirect_to(parent_path(assigns(:parent)))
      end
    end

    context "ユーザがメール認証を完了していない" do
      it "登録ページにリダイレクトする" do
        post :create
        response.should redirect_to(new_parent_path)
      end
    end
  end

end
