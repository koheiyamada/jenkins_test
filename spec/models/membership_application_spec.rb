# coding:utf-8
require 'spec_helper'

describe MembershipApplication do
  let(:student){FactoryGirl.create(:student, status: 'new')}
  let(:parent){FactoryGirl.create(:parent, status: 'new')}

  it '銀行口座を持っていなければ申込できない' do
    MembershipApplication.create(user: student).should_not be_valid
  end

  context 'ユーザーは銀行口座を持っている' do
    before(:each) do
      student.create_account_of_bank('yucho', FactoryGirl.attributes_for(:yucho_account))
    end

    it 'アカウントにひもづけられる' do
      ma = MembershipApplication.create(user: student)
      ma.should be_persisted
    end

    it 'アカウントはnewのまま' do
      expect {
        MembershipApplication.create(user: student)
      }.not_to change{Student.find(student.id).new?}.from(true)
    end

    describe 'accept' do
      it 'ひもづけられたアカウントが有効になる' do
        ma = MembershipApplication.create(user: student)
        expect {
          ma.accept.should be_persisted
        }.to change{Student.find(student.id).active?}.from(false).to(true)
      end
    end

    describe 'of_students' do
      it '受講者からの申込を返す' do
        MembershipApplication.create(user: student)
        MembershipApplication.of_students.should have(1).item
      end

      it '保護者からの申込は含まない' do
        MembershipApplication.create(user: parent)
        MembershipApplication.of_students.should be_empty
      end
    end
  end

  it 'can delete student' do
    begin
      student.destroy
    rescue => e
      puts e.backtrace.join("\n")
      fail
    end
  end

  describe '#reject' do
    before(:each) do
      student.create_account_of_bank('yucho', FactoryGirl.attributes_for(:yucho_account))
    end

    it 'ひもづけられたアカウントが削除される' do
      ma = MembershipApplication.create(user: student)
      user_id = ma.user_id
      Student.find(user_id).should be_present
      ma.reject
      ma.should be_valid
      Student.find_by_id(user_id).should be_blank
    end

    it '巻き添えで自身も削除される' do
      ma = MembershipApplication.create(user: student)
      ma.reject.should be_valid
      MembershipApplication.where(user_id: ma.user_id).should be_empty
    end

    it 'メールが送信される' do
      ma = MembershipApplication.create(user: student)
      Mailer.should_receive(:send_mail)
      ma.reject.should be_valid
    end

    it 'Student#on_membership_application_rejectedが呼ばれる' do
      ma = MembershipApplication.create(user: student)
      Student.any_instance.should_receive(:on_membership_application_rejected)
      ma.reject.should be_valid
    end

    it '本部にメールが送信される' do
      ma = MembershipApplication.create(user: student)
      HqUserMailer.should_receive(:membership_application_rejected)
      ma.reject.should be_valid
    end

    it '本人にメールが送信される' do
      ma = MembershipApplication.create(user: student)
      ma.should be_persisted
      StudentMailer.should_receive(:membership_application_rejected)
      ma.reject.should be_valid
    end
  end
end
