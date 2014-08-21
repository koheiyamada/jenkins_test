# encoding:utf-8

require 'spec_helper'

describe Tutor do
  disconnect_sunspot

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student)}

  it "is valid with valid attributes" do
    FactoryGirl.build(:tutor).should be_valid
  end

  describe '.create' do
    it 'ノートカメラデータが作られる' do
      expect {
        FactoryGirl.create(:tutor)
      }.to change(DocumentCamera, :count).by(1)
    end

    it 'Mailer.send_mail_asyncが呼ばれる' do
      Mailer.should_receive(:send_mail_async)
      FactoryGirl.create(:tutor)
    end

    it '重複するニックネームはダメ' do
      FactoryGirl.create(:tutor, nickname: 'hoge').should be_valid
      FactoryGirl.build(:tutor, nickname: 'hoge').should_not be_valid
    end
  end

  describe "曜日ごとの予定 #weekday_schedules" do
    it "週の予定を保持する" do
      t1 = Time.now
      t2 = 1.hour.since t1
      tutor.weekday_schedules = (0..6).each_with_object([]) do |wday, schedules|
        schedules << WeekdaySchedule.new(wday:wday, start_time:t1, end_time:t2)
      end
      tutor.save!
    end

    it "授業を受け付けていない曜日は空" do
      t1 = Time.now
      t2 = 1.hour.since t1
      (0..6).each do |wday_to_skip|
        schedules = (0..6).each_with_object([]) do |wday, schedules|
          if wday != wday_to_skip
            schedules << WeekdaySchedule.new(wday:wday, start_time:t1, end_time:t2)
          end
        end
        tutor.weekday_schedules = schedules
        tutor.should be_valid
      end
    end
  end

  # TODO: これはもう不要
  describe "#update_available_times" do
    before(:each) do
      t1 = Time.now
      t2 = 2.hour.since t1
      tutor.weekday_schedules = [WeekdaySchedule.new(wday:0, start_time:t1, end_time:t2)]
    end

    it "指定した曜日に予定を入れる" do
      tutor.update_available_times

      times = tutor.available_times.where(start_at: Date.today.to_time .. 3.months.from_now)
      times.should be_present
      times.all? do |t|
        t.start_at.wday.should == 0
      end
    end

    it "3ヶ月先まで予定を入れる" do
      tutor.available_times << AvailableTime.new(start_at:1.year.from_now, end_at:1.hour.since(1.year.from_now))
      Tutor.find(tutor.id).available_times.where("start_at > ?", 3.months.from_now.end_of_month).should have(1).item

      tutor.update_available_times

      Tutor.find(tutor.id).available_times.where("start_at > ?", 3.months.from_now.end_of_month).should be_empty
    end

    it "昨日以前の予定は消す" do
      tutor.available_times << AvailableTime.new(start_at:1.day.ago, end_at:1.hour.since(1.day.ago))
      Tutor.find(tutor.id).available_times.where("start_at < ?", Date.yesterday.end_of_day).should have(1).item

      tutor.update_available_times

      Tutor.find(tutor.id).available_times.where("start_at < ?", Date.yesterday.end_of_day).should be_empty
    end
  end

  describe "教えられる科目 #subjects" do
    it "担当科目のリストを返す" do
      subjects = [
        FactoryGirl.create(:subject),
        FactoryGirl.create(:subject, :name => "Math")
      ]

      tutor = FactoryGirl.create(:tutor, subjects:[subjects[0]])

      s = Tutor.find(tutor.id).subjects
      s.should have(1).item
      s[0].should == subjects[0]
    end
  end

  describe "時間帯判定 #available?(time_range)" do
    it "別のオプションレッスンが入っていればfalse"

    it "ベーシックレッスンが入っていればfalse"
  end

  describe "コンタクトリスト" do
    it "同じ人を何回追加しても人数は変化しない" do
      tutor.contact_list.should be_empty
      tutor.contact_list << student
      5.times do
        tutor.reload.contact_list.count.should == 1
      end
    end

    describe "コンタクトリストを更新する" do
      it "ベーシックレッスンを担当すると生徒が追加される" do
        expect {
          course = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student])
          course.activate!
          tutor.refresh_contact_list
        }.to change{tutor.contact_list.count}.by(1)
      end
    end
  end

  describe "活動状況 #total_lesson_units" do
    describe "#total_lesson_units" do
      it "これまでこなしてきた授業の総単位数を返す" do
        tutor.total_lesson_units.should == 0
      end

      it "授業をこなすと増える" do
        lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now, units:1)
        expect {
          lesson.done!
        }.to change{tutor.total_lesson_units}.from(0).to(1)
      end

      it "2コマ授業をすると2増える" do
        lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now, units:2)
        expect {
          lesson.done!
        }.to change{tutor.total_lesson_units}.from(0).to(2)
      end
    end
  end

  describe "#leave! 退会する" do
    let(:tutor){FactoryGirl.create(:tutor)}

    describe "#leave!" do
      it "チューターは退会済み状態になる" do
        expect {
          tutor.leave!
        }.to change{tutor.left?}.from(false).to(true)
      end

      it "チューターリストに現れなくなる" do
        expect {
          tutor.leave!
        }.to change{Tutor.only_active.include?(tutor)}.from(true).to(false)
      end

      it 'メール送信タスクが積まれる' do
        tutor
        Mailer.should_receive(:send_mail)
        tutor.leave
      end

      context "未開催の授業がある" do
        before(:each) do
          student = FactoryGirl.create(:student)
          lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:2.hour.from_now, units:1)
          lesson.accept!
        end

        it "エラーとなり退会できない" do
          tutor.leave.should_not be_true
          tutor.reload.should be_active
        end

        it ":unfinished_lessonsにエラーがある" do
          tutor.leave
          tutor.errors[:unfinished_lessons].should_not be_empty
        end
      end
    end
  end

  describe '#revive' do
    it '退会済みのチューターが復帰する' do
      tutor = FactoryGirl.create(:tutor)
      tutor.leave.should be_true
      expect {
        tutor.revive.should be_true
      }.to change{Tutor.find(tutor.id).active?}.from(false).to(true)
    end
  end

  describe "本登録化処理の発動" do
    it "担当した授業のCSシートが作成された時に条件を満たしていると本登録になる" do
      lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now, units:1)
      lesson.student_attended(student)
      lesson.done!
      Tutor.any_instance.stub(:condition_to_be_regular_satisfied?).and_return(true)
      #Lesson.any_instance.stub(:check_conflicts).and_return(nil)
      expect {
        FactoryGirl.create(:cs_sheet, author:student, lesson:lesson, score:5)
      }.to change{tutor.regular?}.from(false).to(true)
    end

    it "すでに高評価のCSシートが２枚あれば、レッスンが完了した時点で本登録になる" do
      lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now, units:1)
      lesson.student_attended(student)
      Tutor.any_instance.stub(:condition_to_be_regular_satisfied?).and_return(true)
      expect {
        lesson.done!
      }.to change{tutor.regular?}.from(false).to(true)
    end

    it "条件を満たしていないと本登録にならない" do
      lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now, units:1)
      lesson.student_attended(student)
      lesson.done!
      Tutor.any_instance.stub(:condition_to_be_regular_satisfied?).and_return(false)
      expect {
        FactoryGirl.create(:cs_sheet, author:student, lesson:lesson, score:5)
      }.not_to change{tutor.regular?}
    end
  end

  describe "仮登録から本登録になる #become_regular!" do
    before(:each) do
      @tutor = FactoryGirl.create(:tutor)
    end

    it "給料の変遷が記録に残る" do
      expect {
        @tutor.become_regular!
      }.to change(TutorPriceHistory, :count).by(1)
    end

    context "チューターが学生の場合" do
      before(:each) do
        Tutor.any_instance.stub(:graduated?).and_return(false)
      end

      it "時給が1250円になる" do
        expect {
          @tutor.become_regular!
        }.to change{@tutor.hourly_wage}.from(900).to(1250)
      end
    end

    context "チューターが既卒の場合" do
      before(:each) do
        Tutor.any_instance.stub(:graduated?).and_return(true)
      end

      it "時給が1550円になる" do
        expect {
          @tutor.become_regular!
        }.to change{@tutor.hourly_wage}.from(900).to(1550)
      end
    end

    context '紹介者がいる場合' do
      before(:each) do
        tutor = FactoryGirl.create(:tutor)
        Tutor.any_instance.stub(:reference){tutor}
      end

      it '紹介料が発生する' do
        expect {
          @tutor.become_regular!
        }.to change(Account::TutorReferralFee, :count).by(1)
      end
    end
  end

  describe "時間単位基本報酬改定ポイントを使う #upgrade" do
    before(:each) do
      @tutor = FactoryGirl.create(:tutor)
    end

    context "時間単位基本報酬改定ポイントがない" do
      before(:each) do
        @tutor.info.upgrade_points.should == 0
      end

      it "時給は変わらない" do
        expect {
          @tutor.upgrade
        }.not_to change{@tutor.hourly_wage}
      end

      it "upgradeはfalseを返す" do
        @tutor.upgrade.should be_false
      end
    end

    context "時間単位基本報酬改定ポイントがある" do
      before(:each) do
        @tutor.info.update_attribute(:upgrade_points, 1)
      end

      it "時給が５０円上がる" do
        expect {
          @tutor.upgrade
        }.to change{@tutor.reload.hourly_wage}.by(50)
      end

      it "upgradeはtrueを返す" do
        @tutor.upgrade.should be_true
      end

      it "時間単位基本報酬改定ポイントが１減る" do
        expect {
          @tutor.upgrade
        }.to change{@tutor.info.upgrade_points}.by(-1)
      end
    end
  end

  describe '.monitor_inactive_tutors 長期間ログインしていないチューターの監視' do
    around(:each) do |test|
      Delayed::Worker.delay_jobs = false
      test.call
      Delayed::Worker.delay_jobs = true
    end

    it '３ヶ月(90日)以上ログインしていないチューターをロックする' do
      tutor = FactoryGirl.create(:tutor, last_request_at: 91.days.ago)
      expect {
        Tutor.monitor_inactive_tutors
      }.to change{tutor.reload.left?}.from(false).to(true)
    end

    it '90日以内にログインしているチューターには何もしない' do
      tutor = FactoryGirl.create(:tutor, last_request_at: 89.days.ago)
      expect {
        Tutor.monitor_inactive_tutors
      }.not_to change{tutor.active?}
    end

    describe '' do
      around(:each) do |test|
        Delayed::Worker.delay_jobs = false
        test.call
        Delayed::Worker.delay_jobs = true
      end

      it 'ロックする日の5日前に警告メールを出す' do
        tutor = FactoryGirl.create(:tutor, last_request_at: 85.days.ago)
        TutorMailer.stub(:being_locked).and_return(double().as_null_object)
        TutorMailer.should_receive(:being_locked).with(tutor)
        Tutor.monitor_inactive_tutors
      end
    end
  end

  describe "まとめて昇格する .upgrade_tutors_with_upgrade_points" do
    context "チューターが時間単位基本報酬改定ポイントを1持っている" do
      before(:each) do
        tutor.info.add_upgrade_point!
      end

      it "時間単位基本報酬改定ポイントが1減る" do
        expect {
          Tutor.upgrade_tutors_with_upgrade_points
        }.to change{tutor.info.reload.upgrade_points}.by(-1)
      end

      it "時給が50円上がる" do
        expect {
          Tutor.upgrade_tutors_with_upgrade_points
        }.to change{Tutor.find(tutor.id).hourly_wage}.by(50)
      end
    end

    context "チューターが時間単位基本報酬改定ポイントを2持っている" do
      before(:each) do
        tutor.info.add_upgrade_point!
        tutor.info.add_upgrade_point!
      end

      it "時間単位基本報酬改定ポイントが２減る" do
        expect {
          Tutor.upgrade_tutors_with_upgrade_points
        }.to change{tutor.info.reload.upgrade_points}.by(-2)
      end

      it "時給が100円上がる" do
        expect {
          Tutor.upgrade_tutors_with_upgrade_points
        }.to change{Tutor.find(tutor.id).hourly_wage}.by(100)
      end
    end
  end

  describe "他のチューターを紹介する #make_referral_to" do
    before(:each) do
      @tutor2 = FactoryGirl.create(:tutor, user_name:"tutor2")
    end

    it "紹介したチューターの紹介者として記録される" do
      expect {
        tutor.make_referral_to(@tutor2)
      }.to change{@tutor2.reload.reference}.from(nil).to(tutor)
    end

    it "同じ人を複数回紹介できない" do
      tutor.make_referral_to(@tutor2)
      expect {
        tutor.make_referral_to(@tutor2)
      }.to raise_error
    end

    it "紹介されたチューターが本登録になると紹介料が発生する" do
      expect {
        tutor.make_referral_to(@tutor2)
      }.not_to change(Account::TutorReferralFee, :count)
      expect {
        @tutor2.become_regular!
      }.to change(Account::TutorReferralFee, :count).by(1)
      Account::TutorReferralFee.last.owner.should == tutor
    end
  end

  describe "仮登録チューターが引き受けられるレッスンの数" do
    context "引き受けているレッスンの数がゼロ" do
      it "10個レッスンを引き受けられる" do
        tutor.beginner_tutor_remaining_lesson_count.should == 10
      end
    end

    context "引き受けているレッスンの数が9個" do
      before(:each) do
        tutor.stub_chain("lessons.count").and_return(9)
        tutor.stub_chain("lessons.only_done.count").and_return(0)
      end

      context "評価の良いCSシートの枚数がゼロ" do
        before(:each) do
          tutor.stub_chain("cs_sheets.only_good.count").and_return(0)
        end

        context "未提出のCSシートの枚数がゼロ" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(0)
          end

          it "2つレッスンを引き受けられる" do
            tutor.beginner_tutor_remaining_lesson_count.should == 2
          end
        end

        context "未提出のCSシートの枚数が１" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(1)
          end

          it "1つレッスンを引き受けられる" do
            tutor.beginner_tutor_remaining_lesson_count.should == 1
          end
        end

        context "未提出のCSシートの枚数が２" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(2)
          end

          it "1つレッスンを引き受けられる" do
            tutor.beginner_tutor_remaining_lesson_count.should == 1
          end
        end
      end

      context "評価の良いCSシートの枚数が1" do
        before(:each) do
          tutor.stub_chain("cs_sheets.only_good.count").and_return(1)
        end

        context "未提出のCSシートの枚数がゼロ" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(0)
          end

          it "１つレッスンを引き受けられる" do
            tutor.beginner_tutor_remaining_lesson_count.should == 1
          end
        end

        context "未提出のCSシートの枚数が１" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(1)
          end

          it "１つレッスンを引き受けられる" do
            tutor.beginner_tutor_remaining_lesson_count.should == 1
          end
        end
      end
    end

    context "引き受けているレッスンの数が10" do
      before(:each) do
        tutor.stub_chain("lessons.count").and_return(10)
        tutor.stub_chain("lessons.only_done.count").and_return(0)
      end

      context "評価の良いCSシートの枚数がゼロ" do
        before(:each) do
          tutor.stub_chain("cs_sheets.only_good.count").and_return(0)
        end

        context "未提出のCSシートの枚数がゼロ" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(0)
          end

          context "完了したレッスンの数が10" do
            before(:each) do
              tutor.stub_chain("lessons.only_done.count").and_return(10)
            end

            it "2つレッスンを引き受けられる" do
              tutor.beginner_tutor_remaining_lesson_count.should == 2
            end
          end

          context "完了したレッスンの数が9" do
            before(:each) do
              tutor.stub_chain("lessons.only_done.count").and_return(9)
            end

            it "2つレッスンを引き受けられる" do
              tutor.beginner_tutor_remaining_lesson_count.should == 1
            end
          end

          context "完了したレッスンの数が8" do
            before(:each) do
              tutor.stub_chain("lessons.only_done.count").and_return(8)
            end

            it "2つレッスンを引き受けられる" do
              tutor.beginner_tutor_remaining_lesson_count.should == 0
            end
          end
        end

        context "未提出のCSシートの枚数が１" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(1)
          end

          context "完了したレッスンの数が10" do
            before(:each) do
              tutor.stub_chain("lessons.only_done.count").and_return(10)
            end

            it "1つレッスンを引き受けられる" do
              tutor.beginner_tutor_remaining_lesson_count.should == 1
            end
          end

          context "完了したレッスンの数が9" do
            before(:each) do
              tutor.stub_chain("lessons.only_done.count").and_return(9)
            end

            it "レッスンを引き受けられない" do
              tutor.beginner_tutor_remaining_lesson_count.should == 0
            end
          end
        end

        context "未提出のCSシートの枚数が２" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(2)
          end

          it "レッスンを引き受けられない" do
            tutor.beginner_tutor_remaining_lesson_count.should == 0
          end
        end
      end

      context "評価の良いCSシートの枚数が1" do
        before(:each) do
          tutor.stub_chain("cs_sheets.only_good.count").and_return(1)
        end

        context "未提出のCSシートの枚数がゼロ" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(0)
          end

          context "完了したレッスンの数が10" do
            before(:each) do
              tutor.stub_chain("lessons.only_done.count").and_return(10)
            end

            it "1つレッスンを引き受けられる" do
              tutor.beginner_tutor_remaining_lesson_count.should == 1
            end
          end

          context "完了したレッスンの数が9" do
            before(:each) do
              tutor.stub_chain("lessons.only_done.count").and_return(9)
            end

            it "レッスンを引き受けられない" do
              tutor.beginner_tutor_remaining_lesson_count.should == 0
            end
          end
        end

        context "未提出のCSシートの枚数が１" do
          before(:each) do
            tutor.stub("unreceived_cs_sheets_count").and_return(1)
          end

          context "完了したレッスンの数が10" do
            before(:each) do
              tutor.stub_chain("lessons.only_done.count").and_return(10)
            end

            it "レッスンを引き受けられない" do
              tutor.beginner_tutor_remaining_lesson_count.should == 0
            end
          end
        end
      end

      context "評価の良いCSシートの枚数が2" do
        before(:each) do
          tutor.stub_chain("cs_sheets.only_good.count").and_return(2)
          tutor.stub("unreceived_cs_sheets_count").and_return(0)
        end

        it "レッスンを引き受けられない" do
          tutor.beginner_tutor_remaining_lesson_count.should == 0
        end
      end
    end
  end

  describe '#destroy' do
    context '担当授業がある' do
      before(:each) do
        @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      end

      it '授業担当チューターがnilになる' do
        expect {
          tutor.leave.should be_true
          tutor.destroy
        }.to change{Lesson.find(@lesson.id).tutor_id}.to(nil)
      end
    end

    context 'ベーシックレッスンがある' do
      before(:each) do
        @basic_lesson = FactoryGirl.create(:basic_lesson_info, tutor: tutor, students: [student])
        @basic_lesson.submit_to_tutor
        @basic_lesson.accept
      end

      it '担当チューターがnilになる' do
        expect {
          tutor.leave.should be_true
          tutor.destroy
        }.to change{BasicLessonInfo.find(@basic_lesson.id).tutor_id}.to(nil)
      end
    end

    it 'DocumentCameraが消える' do
      tutor = FactoryGirl.create(:tutor)
      expect {
        tutor.destroy
      }.to change(DocumentCamera, :count).by(-1)
    end
  end

  #describe '#wage_of_this_month' do
  #  it '現在までの今月の稼ぎを金額で返す' do
  #    t = 2.hours.from_now
  #    lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student], start_time: t)
  #    lesson.accept
  #    lesson.start!
  #    lesson.close
  #
  #    Time.stub(:now){1.day.from_now}
  #
  #    tutor.wage_of_this_month.should == lesson.tutor_wage
  #  end
  #end

  describe '#become_special_tutor' do
    it '仮登録チューターがスペシャルチューターになる' do
      tutor = FactoryGirl.create(:tutor)
      tutor.should be_beginner
      expect {
        tutor.become_special_tutor
      }.to change{Tutor.find(tutor.id).is_a?(SpecialTutor)}.from(false).to(true)
    end
  end

  describe '#become_normal_tutor' do
    it 'スペシャルチューターが通常のチューターになる' do
      tutor = FactoryGirl.create(:tutor)
      tutor.should be_beginner
      tutor.become_special_tutor
      tutor = Tutor.find(tutor.id)
      expect {
        tutor.become_normal_tutor
      }.to change{Tutor.find(tutor.id).is_a?(SpecialTutor)}.from(true).to(false)
    end
  end

  describe '#become_beginner' do
    subject {
      tutor = FactoryGirl.create(:tutor)
      tutor.become_regular!
      tutor
    }

    before(:each) do
      subject.should be_regular
    end

    it '本登録のチューターが仮登録に戻る' do
      subject.become_beginner
      subject.should be_beginner
    end

    it '時給も戻る' do
      subject.become_beginner
      subject.reload.hourly_wage.should == TutorPrice.beginner_tutor_default_hourly_wage
    end
  end
end
