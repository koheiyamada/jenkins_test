# coding:utf-8
require 'spec_helper'

describe TutorAppForm do
  let(:form) {FactoryGirl.create(:tutor_app_form)}

  before(:each) do
    @form = FactoryGirl.build(:tutor_app_form)
  end

  it 'is not valid without first name' do
    @form.first_name = nil
    @form.should_not be_valid
  end

  it 'is not valid without last name' do
    @form.last_name = nil
    @form.should_not be_valid
  end

  #it "is not valid without phone number" do
  #  @form.phone_number = nil
  #  @form.should_not be_valid
  #end

  it 'is not valid without skype id' do
    @form.skype_id = nil
    @form.should_not be_valid
  end

  #it "is not valid without nickname" do
  #  @form.nickname = nil
  #  @form.should_not be_valid
  #end

  #it "is not valid without current address" do
  #  @form.current_address = nil
  #  @form.should_not be_valid
  #end

  #it "is not valid without hometown address" do
  #  @form.hometown_address = nil
  #  @form.should_not be_valid
  #end

  #it "is not valid without phone_email" do
  #  @form.phone_mail = nil
  #  @form.should_not be_valid
  #end

  it 'is not valid without pc_email' do
    @form.pc_mail = nil
    @form.should_not be_valid
  end

  it 'is valid with valid attributes' do
    @form.should be_valid
  end

  describe '申込を却下する #reject!' do
    it '申込フォームの状態を「却下」にする' do
      expect{form.reject!}.to change{form.rejected?}.from(false).to(true)
    end
  end

  describe 'チューターアカウントを作成する create_account!' do
    before(:each) do
      form.should be_persisted
    end

    it 'Tutorモデルが増える' do
      expect {
        form.create_account!
      }.to change(Tutor, :count).by(1)
    end

    it 'チューターアカウントには写真がセットされる' do
      tutor = form.create_account!
      tutor.photo.should be_present
      tutor.password.should be_present
    end

    it 'フォームとアカウントはひもづけられる' do
      tutor = form.create_account!
      form.should_not be_changed
      TutorAppForm.find(form.id).tutor.should == tutor
    end

    #it "チューターアカウントには住所がセットされる" do
    #  TutorAppForm.find(form.id).current_address.should be_present
    #  tutor = form.create_account!
    #  tutor.current_address.should be_present
    #  tutor.hometown_address.should be_present
    #  TutorAppForm.find(form.id).current_address.should be_present
    #end

    it 'チューターは仮登録になる' do
      tutor = form.create_account!
      tutor.should be_beginner
    end
  end
end
