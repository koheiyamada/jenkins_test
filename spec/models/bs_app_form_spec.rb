# coding:utf-8
require 'spec_helper'

describe BsAppForm do
  let(:form) {FactoryGirl.create(:bs_app_form)}

  before(:each) do
    @form = FactoryGirl.build(:bs_app_form)
  end

  it "is not valid without first name" do
    @form.first_name = nil
    @form.should_not be_valid
  end

  it "is not valid without last name" do
    @form.last_name = nil
    @form.should_not be_valid
  end

  it "is valid without corporate name" do
    @form.corporate_name = nil
    @form.should be_valid
  end

  it "is not valid without email" do
    @form.email = nil
    @form.should_not be_valid
  end

  it "is valid with valid attributes" do
    @form.should be_valid
  end

  describe "申込を却下する #reject!" do
    it "申込フォームの状態を「却下」にする" do
      expect{form.reject!}.to change{form.rejected?}.from(false).to(true)
    end
  end

  describe "申込を受け入れる create_bs_and_bs_user!" do
    it "Bsオブジェクトが増える" do
      expect {
        form.create_bs_and_bs_user!
      }.to change(Bs, :count).by(1)
    end

    it "BsUserオブジェクトが増える" do
      expect {
        form.create_bs_and_bs_user!
      }.to change(BsUser, :count).by(1)
    end

    it "BsUserに写真もコピーされる" do
      bs_user = form.create_bs_and_bs_user!
      bs_user.photo.should be_present
    end
  end
end
