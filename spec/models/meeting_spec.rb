# coding: utf-8
require 'spec_helper'

describe Meeting do
  let(:hq_user){FactoryGirl.create(:hq_user)}
  let(:student){FactoryGirl.create(:student)}
  let(:parent){FactoryGirl.create(:parent)}
  let(:meeting){FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, student])}

  describe '作成する' do
    it '作成者があれば登録処理中状態で作成できる' do
      meeting = FactoryGirl.create(:meeting, creator: hq_user)
      meeting.should be_registering
    end
  end

  describe '#finish_registering' do
    before(:each) do
      @meeting = FactoryGirl.create(:meeting, creator: hq_user)
    end

    it '２人以上の参加者と候補日１つ以上があればよい' do
      @meeting.members << hq_user
      @meeting.members << student
      @meeting.schedules << MeetingSchedule.new(datetime: 1.day.from_now)
      m = @meeting.finish_registering
      m.should be_valid
    end

    it '参加者１人だとダメ' do
      @meeting.members << hq_user
      @meeting.schedules << MeetingSchedule.new(datetime: 1.day.from_now)
      m = @meeting.finish_registering
      m.should_not be_valid
    end

    it '候補日が設定されていなくてもダメ' do
      @meeting.members << hq_user
      @meeting.members << student
      @meeting.schedules = []
      m = @meeting.finish_registering
      m.should_not be_valid
    end

    it '候補日は未来' do
      @meeting.members << hq_user
      @meeting.members << student
      @meeting.schedules << MeetingSchedule.new(datetime: -1.day.from_now)
      @meeting.finish_registering.should_not be_valid
    end

    it '同じ人を複数登録することはできない' do
      @meeting.members << hq_user
      @meeting.members << hq_user
      @meeting.members.should have(1).item
    end

  end

  describe '#fix_schedule' do
    before(:each) do
      @meeting = FactoryGirl.create(:meeting, creator: hq_user)
    end

    it '２人以上の参加者と開催日があればよい' do
      @meeting.members << hq_user
      @meeting.members << student
      @meeting.datetime = 1.hour.from_now
      m = @meeting.fix_schedule
      m.should be_valid
    end

    it '開催日がなければエラー' do
      @meeting.members << hq_user
      @meeting.members << student
      @meeting.datetime = nil
      m = @meeting.fix_schedule
      m.should_not be_valid
    end
  end

  describe '#close' do
    before(:each) do
      @meeting = FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, student])
    end

    context 'scheduled 状態の場合' do
      before(:each) do
        @meeting.datetime = 1.hour.from_now
        @meeting.fix_schedule.should be_valid
      end

      it '終了状態に移行する' do
        expect {
          @meeting.close.should be_valid
        }.to change{Meeting.find(@meeting.id).done?}.from(false).to(true)
      end
    end
  end

  describe '#on_skipped 面談がすっぽかされたことを通知する' do
    before(:each) do
      @meeting = FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, parent])
    end

    context '面談予定日当日の場合' do
      it 'メッセージ送信に失敗する' do
        @meeting.stub(:datetime){Time.current}
        ParentMailer.should_not_receive(:meeting_skipped)

        @meeting.on_skipped
      end
    end

    context '面談予定日の前日以前の場合' do
      it 'メールは送られない' do
        @meeting.stub(:datetime){1.day.from_now}
        ParentMailer.should_not_receive(:meeting_skipped)

        @meeting.on_skipped
      end
    end

    context '現在が面談予定日の翌日以降の場合' do
      before(:each) do
        @meeting.stub(:datetime){-1.day.from_now}
      end

      it 'バックグラウンドジョブが積まれる' do
        expect {
          @meeting.on_skipped
        }.to change(Delayed::Job, :count).by(1)
      end

      it 'ジョブの内容は#send_skipped_messageの呼び出し' do
        @meeting.on_skipped
        job = Delayed::Job.last
        job.handler.should match('send_skipped_message')
      end

      it 'ジョブは朝8時に実行する' do
        @meeting.on_skipped
        job = Delayed::Job.last
        job.run_at.hour.should == 8
      end
    end
  end

  describe '#send_skipped_message' do
    before(:each) do
      @meeting = FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, parent])
    end

    it '保護者にメールを送る' do
      mail = double('mail').as_null_object
      ParentMailer.should_receive(:meeting_skipped).and_return(mail)
      mail.should_receive(:deliver)

      @meeting.send_skipped_message
    end
  end

  describe '#host' do
    it '本部かBSのアカウントを返す' do
      @meeting = FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, parent])
      @meeting.host.should == hq_user
    end
  end

  describe '#host_name' do
    it '面談に参加する本部か合うんとかBSアカウントの氏名を返す' do
      @meeting = FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, parent])
      hq_user.full_name.should be_present
      @meeting.host_name.should == hq_user.full_name
    end
  end

  describe '.handle_skipped_meetings' do
    it '指定した日の面談のうち、完了していないものに対してon_skippedを呼び出す' do
      (1..10).map do |i|
        datetime = Time.current.change(hour: i)
        meeting = FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, parent], datetime: datetime)
        meeting.fix_schedule.should be_scheduled
        if i.odd?
          meeting.close
        end
        meeting
      end

      count = 0
      Meeting.any_instance.stub(:on_skipped){count += 1}

      Meeting.handle_skipped_meetings(Date.today)
      count.should == 5
    end
  end

  describe '#on_skipped' do
    it '参加者にメールを送る' do
      meeting.stub(:overdue?){true}
      meeting.should_receive(:send_at)
      meeting.on_skipped
    end
  end

  describe '#send_skipped_message' do
    it '参加者にメールを送る' do
      HqUserMailer.should_receive(:meeting_skipped)
      StudentMailer.should_receive(:meeting_skipped)
      meeting.send_skipped_message
    end
  end

  describe 'メンバーを削除する' do
    describe '受講者だけを削除する' do
      before(:each) do
        @meeting = FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, student])
      end

      it '参加者が一人減る' do
        expect {
          @meeting.members.delete(student)
        }.to change{@meeting.members.reload.count}.by(-1)
        @meeting.members.include?(student).should be_false
      end
    end
  end

  describe '#students' do
    before(:each) do
      @meeting = FactoryGirl.create(:meeting, creator: hq_user, members: [hq_user, student])
    end

    it '受講者の参加者のみを返す' do
      students = @meeting.students
      students.should have(1).item
      students.first.should == student
    end

    describe '受講者メンバーを削除する' do
      before(:each) do
        @meeting.students.should have(1).item
      end

      it '削除してもアカウントは残っている' do
        expect {
          @meeting.students.destroy_all
        }.not_to change(Student, :count)
      end

      it 'MeetingMemberは１つ減る' do
        expect {
          @meeting.students.destroy_all
        }.to change(MeetingMember, :count).by(-1)
      end
    end

    describe '受講者メンバーを削除する その２（destroy_allを使わない）' do
      before(:each) do
        @meeting.students.should have(1).item
      end

      it '削除してもアカウントは残っている' do
        expect {
          @meeting.members.delete(@meeting.members.of_type(Student))
        }.not_to change(Student, :count)
      end

      it 'MeetingMemberは１つ減る' do
        expect {
          @meeting.members.delete(@meeting.members.of_type(Student))
        }.to change(MeetingMember, :count).by(-1)
      end
    end
  end

end
