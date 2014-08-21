# encoding:utf-8
require 'spec_helper'

describe BsUser do
  disconnect_sunspot

  subject {FactoryGirl.create(:bs_user)}
  let(:student) {FactoryGirl.create(:active_student)}

  it "is valid with valid attributes" do
    FactoryGirl.build(:bs_user).should be_valid
  end

  it '重複するニックネームはダメ' do
    FactoryGirl.create(:bs_user, nickname: 'hoge').should be_valid
    FactoryGirl.build(:bs_user, nickname: 'hoge').should_not be_valid
  end

  it '教育コーチと同じニックネームはOK' do
    FactoryGirl.create(:coach, nickname: 'hoge').should be_valid
    FactoryGirl.build(:bs_user, nickname: 'hoge').should be_valid
  end

  describe "#send_message" do
    it "チューターにメッセージを送る" do
      bs_user = FactoryGirl.create(:bs_user)
      tutor = FactoryGirl.create(:tutor)

      msg = bs_user.send_message(title:"Hello", text:"This is a testmail", recipient:tutor)

      msg.title.should == "Hello"
      msg.text.should == "This is a testmail"
      tutor.received_messages.should == [msg]
      bs_user.sent_messages.should == [msg]
    end
  end

  describe "面談を設定する" do

    describe "保護者との面談を設定する" do
      it "自分と保護者との面談を設定する" do
        bs_user = FactoryGirl.create(:bs_user)
        parent = FactoryGirl.create(:parent)
        t = 1.week.from_now
        meeting = bs_user.arrange_interview(with:parent, at:t)
        meeting.should be_a(Interview)
        meeting.start_time.should == t
        meeting.creator.should == bs_user
        meeting.user1.should == bs_user
        meeting.user2.should == parent
      end
    end
  end

  describe '#assign_student' do
    it '受講者とのヒモ付が増える' do
      expect {
        subject.assign_student(student)
      }.to change(StudentCoach, :count).by(1)
    end

    it '当該受講者のコーチとなる' do
      subject.assign_student(student)
      Rails.logger.debug '------------------------------------------------ HERE'
      Student.find(student.id).coach.should == subject
      Rails.logger.debug '------------------------------------------------ HERE 2'
    end

    context '紐付けられている受講者が別の教育コーチとひもづけられている場合' do
      before(:each) do
        @coach = FactoryGirl.create(:coach)
        @coach.assign_student(student)
        student.reload.student_coach.should be_present
      end

      it 'その教育コーチの管理受講者数が減る' do
        expect {
          subject.assign_student(student)
        }.to change{@coach.reload.students.count}.by(-1)
      end
    end
  end
end
