# coding:utf-8
require 'spec_helper'

describe Parent do
  around(:each) do |test|
    Delayed::Worker.delay_jobs = false
    test.call
    Delayed::Worker.delay_jobs = true
  end

  let(:parent) {FactoryGirl.create(:active_parent)}
  let(:hq_user) {FactoryGirl.create(:hq_user)}
  let(:student) {FactoryGirl.create(:active_student)}

  it "登録フォームを持てる" do
    parent = FactoryGirl.build(:parent)
    form = FactoryGirl.create(:parent_registration_form)
    parent.registration_form = form
    parent.save.should == true

    Parent.find(parent.id).registration_form.should == form
    ParentRegistrationForm.find(form.id).parent.should == parent
  end

  describe "作成" do
    it "必要なパラメータが揃っていればOK" do
      FactoryGirl.build(:parent).should be_valid
    end

    it "住所が必要" do
      FactoryGirl.build(:parent, address:nil).should_not be_valid
    end

    it "emailが必要" do
      FactoryGirl.build(:parent, email:nil).should_not be_valid
    end

    it "電話番号が必要" do
      FactoryGirl.build(:parent, phone_number:nil).should_not be_valid
    end

    it "姓・名が必要" do
      FactoryGirl.build(:parent, first_name:nil).should_not be_valid
      FactoryGirl.build(:parent, last_name:nil).should_not be_valid
    end

    it "ユーザーIDが必要" do
      FactoryGirl.build(:parent, user_name:nil).should_not be_valid
    end

    it "パスワードが必要" do
      FactoryGirl.build(:parent, password:nil).should_not be_valid
    end

    it '重複するニックネームはダメ' do
      FactoryGirl.create(:parent, nickname: 'hoge').should be_valid
      FactoryGirl.build(:parent, nickname: 'hoge').should_not be_valid
    end

    context "住所を担当するBSが存在する" do
      before(:each) do
        postal_code = FactoryGirl.create(:postal_code)
        code1, code2 = postal_code.code1, postal_code.code2
        address = FactoryGirl.create(:address, postal_code1: code1, postal_code2: code2)
        @bs = FactoryGirl.create(:bs, address: address, area_code: postal_code.area_code.code)
        address2 = FactoryGirl.create(:address, postal_code1: code1, postal_code2: code2)
        @parent = FactoryGirl.build(:parent, address: address2)
      end

      it "作成時に自動的にBSが割り当てられる" do
        expect {
          @parent.save!
        }.to change{@parent.organization}.from(nil).to(@bs)
      end
    end

    context "住所を担当するBSが存在しない" do
      it "作成時に本部が割り当てられる" do
        @parent = FactoryGirl.build(:parent, address:FactoryGirl.create(:address))
        expect {
          @parent.save!
        }.to change{@parent.organization}.from(nil).to(Headquarter.instance)
      end
    end
  end

  describe "担当BSを変更する" do
    it "担当BSが変わる" do
      bs = FactoryGirl.create(:bs)
      parent = FactoryGirl.create(:parent)
      parent.organization.should == Headquarter.instance
      parent.change_bs!(bs)
      parent.organization.should == bs
    end
  end

  describe '#leave! 退会処理' do
    let(:parent) {FactoryGirl.create(:active_parent)}

    it '非アクティブ化する' do
      expect{parent.leave!}.to change{Parent.find(parent.id).active?}.from(true).to(false)
    end

    it 'on_leftが呼ばれる' do
      parent.should_receive(:on_left)
      parent.leave!
    end

    describe '管理している受講者の扱い' do

      it '受講者ごとに#leaveが呼ばれる' do
        student = FactoryGirl.create(:student, parent:parent)
        parent.reload
        parent.stub(:students).and_return([student])
        student.should_receive(:leave).and_return(student)

        parent.leave!
      end

      it '管理している生徒もすべて非アクティブ化する' do
        student = FactoryGirl.create(:active_student, parent:parent)
        expect {
          parent.reload.leave!
        }.to change{Student.find(student.id).active?}.from(true).to(false)
      end

      it '受講者がレッスン中だと退会できずに保護者の退会も失敗する' do
        student = FactoryGirl.create(:active_student, parent:parent)
        parent.reload
        parent.stub(:students).and_return([student])
        student.stub(:in_lesson?){true}
        parent.leave
        parent.errors.any?.should be_true
        parent.errors.full_messages.should == ['管理している受講者の退会処理ができませんでした。レッスン中、面談中などの場合は受講者の退会ができません。']
        parent.students.first.errors[:active] == ['レッスン中のため退会処理を実行できません。']
        Parent.find(parent.id).should be_active
      end
    end

    context '面談予定がある場合' do
      before(:each) do
        meeting = FactoryGirl.create(:meeting, members: [hq_user, parent], datetime: 1.hour.from_now)
        parent.meetings.should have(1).item
      end

      it 'それらは削除される' do
        expect {
          parent.leave.should be_true
        }.to change(Meeting, :count).by(-1)
      end
    end
  end

  describe '#lock' do
    it 'ロックされる' do
      parent.lock.should be_valid
      parent.should be_locked
    end
  end

  describe '#create_membership_cancellation' do
    before(:each) do
      parent.students << student
    end

    it '最終的には退会状態となる' do
      expect {
        parent.create_membership_cancellation(reason: 'Hello').should be_persisted
      }.to change{Parent.find(parent.id).left?}.from(false).to(true)
    end

    it '管理している受講者も最終的には退会状態となる' do
      expect {
        parent.create_membership_cancellation(reason: 'Hello')
      }.to change{Student.find(student.id).left?}.from(false).to(true)
    end

    it '管理している受講者にもMembershipCancellationが作られる' do
      expect {
        parent.create_membership_cancellation(reason: 'Hello')
      }.to change{Student.find(student.id).membership_cancellation.present?}.from(false).to(true)
    end

    describe '退会処理の自動実行' do

      it '#leaveが呼ばれる' do
        parent.class.any_instance.should_receive(:leave).and_return(parent)
        parent.create_membership_cancellation(reason: 'Hello')
      end

      it '保護者は退会済みになる' do
        expect {
          parent.create_membership_cancellation(reason: 'Hello')
        }.to change{Parent.find(parent.id).active?}.from(true).to(false)
      end

      it '管理している受講者は退会済みになる' do
        expect {
          parent.create_membership_cancellation(reason: 'Hello')
        }.to change{Student.find(student.id).active?}.from(true).to(false)
      end
    end

    context '管理している受講者がレッスン中' do
      before(:each) do
        Student.any_instance.stub(:in_lesson?){true}
      end

      it '退会できない' do
        parent.students.should be_present
        parent.create_membership_cancellation(reason: 'Hello').should_not be_persisted
      end
    end
  end

  describe '#membership_cancellation.destroy' do
    before(:each) do
      parent.create_membership_cancellation(reason: 'Hello').should be_persisted
      parent.reload.should_not be_active
    end

    it 'アカウントが復帰する' do
      expect {
        parent.membership_cancellation.destroy
      }.to change{parent.reload.active?}.from(false).to(true)
    end
  end

  describe 'destroy' do
    it '受講者も削除される' do
      student = FactoryGirl.create(:student, parent: parent)
      expect {
        Parent.find(parent.id).destroy
      }.to change(Student, :count).by(-1)
    end
  end

  describe 'メールアドレスを変更する' do
    it '本人にメールを送信する' do
      ParentMailer.should_receive(:user_email_changed).with(parent)
      parent.update_attribute(:email, 'shimokawa2@soba-project.com')
    end
  end
end
