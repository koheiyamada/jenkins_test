# encoding:utf-8
require 'spec_helper'

describe RegistrationStudentsController do

  describe "GET :confirm" do
    context "tokenがない場合" do
      it "confirmation_errorテンプレートを描画する" do
        get :confirm
        response.should render_template("confirmation_error")
      end
    end

    context "無効なtokenがある場合" do
      it "confirmation_errorテンプレートを描画する" do
        get :confirm, token:"hogehoge"
        response.should render_template("confirmation_error")
      end
    end

    context "有効なtokenがある場合" do
      before(:each) do
        student_registration_form = mock_model(StudentRegistrationForm).as_null_object
        StudentRegistrationForm.should_receive(:find_by_confirmation_token).and_return(student_registration_form)
        student_registration_form.stub(:student){nil}
        student_registration_form.stub(:confirmation_token){'hogehoge'}
      end

      it '生徒情報入力フォームにリダイレクトする' do
        get :confirm, token:"hogehoge"
        response.should redirect_to(new_student_path)
      end

      it "セッションにトークンをセットする" do
        get :confirm, token:"hogehoge"
        session[:confirmation_token].should == "hogehoge"
      end
    end
  end

  describe "GET :new" do
    context 'セッションにトークンがセットされていて、登録フォームからまだ受講者アカウントが作成されていない' do
      before(:each) do
        session[:confirmation_token] = "hoge"
        student_registration_form = mock_model(StudentRegistrationForm).as_null_object
        StudentRegistrationForm.should_receive(:find_by_confirmation_token).and_return(student_registration_form)
        student_registration_form.stub(:student){nil}
      end

      it "assigns @student" do
        get :new
        assigns(:student).should be_a(Student)
      end
    end

  end

  describe "POST :create" do
    context "必要な情報が揃っている場合" do
      let(:student_registration_form) { FactoryGirl.create(:student_registration_form) }

      before(:each) do
        @student_registration_form_attrs = FactoryGirl.attributes_for(:student_registration_form, address:nil)
        @student_attrs = FactoryGirl.attributes_for(:student, email: 'shimokawa@soba-project.com')
        @address_attrs = FactoryGirl.attributes_for(:address)
        StudentRegistrationForm.stub(:find_by_confirmation_token).and_return(student_registration_form)
        student_registration_form.stub(:email).and_return('shimokawa@soba-project.com')
        student_registration_form.stub(:student).and_return(nil)
        @student = FactoryGirl.create(:student)
      end

      def has_web_camera
        {answer_option_code: 'built_in'}
      end

      def how_to_find
        {answer_option: 'search_engine_yahoo'}
      end

      def reason_to_enroll
        {answer_options: {'attractive_tutors' => {selected: '1'}}}
      end

      def student_params
        { student: @student_attrs,
          student_info: FactoryGirl.attributes_for(:student_info),
          address: @address_attrs,
          payment_method: {type: CreditCardPayment.name},
          has_web_camera: has_web_camera,
          how_to_find: how_to_find,
          reason_to_enroll: reason_to_enroll}
      end

      it "生徒アカウントを作成する" do
        Student.should_receive(:new).and_return(@student)
        @student.should_receive(:save!).and_return(true)
        controller.should_receive(:sign_in).with(:user, @student)

        post :create, student_params
      end

      it "ユーザ情報を更新する" do
        student_registration_form.stub(:email).and_return("shimokawa@soba-project.com")

        post :create, student_params
      end

      it "クレジットカード登録画面にリダイレクトする" do
        student_registration_form.stub(:email).and_return("shimokawa@soba-project.com")

        post :create, student_params
        student = assigns(:student)
        p student.errors.full_messages
        response.should redirect_to(student_path(student))
      end

      #it "StudentRegistrationFormオブジェクトと生徒アカウントが関連付けられる" do
      #  Student.should_receive(:new).and_return(@student)
      #  @student.should_receive(:save).and_return(true)
      #  post :create, student_registration_form:@student_registration_form_attrs, student:@student_attrs, address:@address_attrs
      #end
    end
  end

end
