# coding:utf-8
require "spec_helper"

describe UserMailer do
  describe "registration_accepted" do
    before(:each) do
      @email = "shimokawa@soba-project.com"
      @confirmation_token = "hogehgoe"
      @params = {
        to: @email,
        confirmation_url:confirm_parents_url(token: @confirmation_token)
      }
    end

    let(:mail) {
      UserMailer.registration_accepted(@params)
    }

    it "raise an error without 'to' parameter" do
      @params[:to] = nil
      expect {
        UserMailer.registration_accepted(@params)
      }.to raise_error
    end

    it "raise an error without 'confirmation_url' parameter" do
      @params[:confirmation_url] = nil
      expect {
        UserMailer.registration_accepted(@params)
      }.to raise_error
    end

    it "renders the headers" do
      mail.subject.should eq("[AID Tutoring System]登録を受け付けました")
      mail.to.should eq([@email])
      mail.from.should eq(["noreply@aidnet.jp"])
    end

    it "renders the body" do
      mail.body.encoded.should match(Regexp.escape("http://localhost/registration/parents/confirm?token=#{@confirmation_token}"))
    end
  end

end
