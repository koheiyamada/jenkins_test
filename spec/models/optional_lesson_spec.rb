# encoding:utf-8
require 'spec_helper'

describe OptionalLesson do
  disconnect_sunspot
  
  let(:subject) {FactoryGirl.create(:subject)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:tutor2) {FactoryGirl.create(:tutor, user_name:"tutor2")}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:student, organization:bs)}
  let(:student2) {FactoryGirl.create(:student)}
  #let(:optional_lesson) {FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])}
  let(:accepted_lesson) {
    lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student])
    lesson.accept
    lesson
  }

  describe '.create' do
    before(:each) do
      @lesson = FactoryGirl.build(:optional_lesson, tutor:tutor, students:[student])
    end

    it "チュータ、生徒一人以上、年、月、日、時間、分、授業時間、科目があればvalid" do
      t = 1.day.from_now
      lesson = OptionalLesson.new do |l|
        l.subject = subject
        l.tutor = tutor
        l.start_time = t
        l.students << student
      end
      lesson.should be_valid
    end

    it "is valid when valid attributes are given" do
      @lesson.should be_valid
    end

    it "チューターがセットされていなければinvalid" do
      @lesson.tutor = nil
      @lesson.should be_invalid
    end

    it "生徒が一人もセットされていなければinvalid" do
      @lesson.students = []
      @lesson.should be_invalid
    end

    it "科目はオプション" do
      @lesson.subject = nil
      @lesson.should be_valid
    end

    it "開始時刻が必須" do
      @lesson.start_time = nil
      @lesson.should be_invalid
    end

    it "終了時刻が与えられなければ自動的に計算される" do
      @lesson.end_time = nil
      @lesson.should be_valid
      Lesson.duration_per_unit.minutes.since(@lesson.start_time).should == @lesson.end_time
    end
  end

  describe "状態変化" do
    let(:lesson) {FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])}

    it "初期状態はnew（依頼中）" do
      lesson.should be_new
      lesson.should_not be_show_on_calendar
      lesson.should be_schedule_fixed
    end

    context "レッスン成立時" do
      before(:each) do
        lesson.accept!
      end

      it "受け付けるとacceptになり、日付確定＆カレンダーに表示" do
        lesson.should be_show_on_calendar
        lesson.should be_schedule_fixed
      end

      context "スケジュール変更中にする" do
        before(:each) do
          lesson.reschedule!
          lesson.should be_rescheduling
        end

        it "カレンダーには表示されないが、日付は確保される" do
          lesson.should_not be_show_on_calendar
          lesson.should be_schedule_fixed
        end
      end
    end
  end

  describe "#accept!" do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    it "状態がacceptedになる" do
      expect {
        @lesson.accept!
      }.to change{@lesson.accepted?}.from(false).to(true)
    end

    context '時間が重なっている別のレッスン申込がある場合' do
      before(:each) do
        @lesson2 = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student2], start_time:@lesson.start_time)
      end

      it 'そのレッスンは拒否扱いになる' do
        expect {
          @lesson.accept!
        }.to change{Lesson.find(@lesson2.id).rejected?}.from(false).to(true)
      end
    end
  end

  describe '#establish' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
      @lesson.should_not be_established
    end

    around(:each) do |test|
      Delayed::Worker.delay_jobs = false
      test.call
      Delayed::Worker.delay_jobs = true
    end

    it 'established?がtrueになる' do
      expect {
        @lesson.establish
      }.to change{@lesson.established?}.from(false).to(true)
    end

    it '参加する受講者のon_monthly_charge_updatedが呼ばれる' do
      Student.any_instance.should_receive(:on_monthly_charge_updated)
      @lesson.establish
    end

    it 'UserMonthlyStat#update_usageが呼ばれる' do
      monthly_stat = mock_model(UserMonthlyStat).as_null_object
      monthly_stat.stub(:valid?){true}
      UserMonthlyStat.any_instance.should_receive(:update_usage){monthly_stat}
      @lesson.establish
    end

    it 'キャンセル済みなら何も起きない' do
      @lesson.cancel.should be_true
      @lesson.should be_cancelled
      expect {
        @lesson.establish.should be_false
        @lesson.errors.should_not be_empty
      }.not_to change{@lesson.reload.established?}.from(false)
    end

    it 'すでに成立済みでもtrueを返すが何も起きない' do
      @lesson.establish.should be_true
      Student.any_instance.should_not_receive(:on_monthly_charge_updated)

      expect {
        @lesson.establish.should be_true
      }.not_to change{@lesson.reload.established?}.from(true)
    end
  end

  describe '#start! レッスンを開始する #start!' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    it "状態が「レッスン実施中」になる" do
      expect {
        @lesson.start!
      }.to change{@lesson.open?}.from(false).to(true)
    end

    context "チューターが遅刻した" do
      before(:each) do
        Time.stub(:now).and_return(5.minutes.since(@lesson.start_time))
      end

      it "遅刻フラグが立つ" do
        expect {
          @lesson.start!
        }.to change{@lesson.delayed?}.from(false).to(true)
      end
    end
  end

  describe '#done! レッスンを終了する #done!' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    # around(:each) do |test|
    #   Delayed::Worker.delay_jobs = false
    #   test.call
    #   Delayed::Worker.delay_jobs = true
    # end

    it "Tutor#on_lesson_doneを呼ぶ" do
      @lesson.tutor.should_receive(:on_lesson_done)
      @lesson.done!
    end

    it 'バックグラウンドジョブが１つ増える' do
      expect {
        @lesson.done!
      }.to change(Delayed::Job, :count).by(3)
    end

    context '支払成立済' do
      before(:each) do
        @lesson.establish
      end

      around(:each) do |test|
        Delayed::Worker.delay_jobs = false
        test.call
        Delayed::Worker.delay_jobs = true
      end

      it 'update_accountingsが呼ばれる' do
        @lesson.should_receive(:update_accountings)
        @lesson.done!
      end

      it '月次集計がバックグラウンドで更新される' do
        n = Account::OptionalLessonTutorFee.count
        @lesson.done!
        Account::OptionalLessonTutorFee.count.should == (n + 1)
      end

      it '本部等の月次集計リクエストの数が増える' do
        expect {
          @lesson.done!
        }.to change(MonthlyStatementUpdateRequest, :count).by(1)
      end
    end
  end

  describe "時刻関連" do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    describe "#tutor_entry_start_time" do
      it "授業開始時刻の10分前を返す" do
        @lesson.tutor_entry_start_time.should == 10.minutes.ago(@lesson.start_time)
      end
    end

    describe "#time_door_open_for_student" do
      it "授業開始時刻の5分前を返す" do
        @lesson.student_entry_start_time.should == 5.minutes.ago(@lesson.start_time)
      end
    end

    describe '#dropout_closing_time' do
      it 'nilを返す' do
        @lesson.dropout_closing_time.should be_nil
      end

      it 'レッスンが開始していれば、開始時刻の10分後を返す' do
        t = 1.minute.since(@lesson.start_time)
        @lesson.stub(:started_at){t}
        @lesson.dropout_closing_time.should == 10.minutes.since(t)
      end
    end

    describe '#time_lesson_end' do
      context '授業が開始されていない場合' do
        it '終了予定時刻を返す' do
          @lesson.time_lesson_end.should == @lesson.end_time
        end
      end

      context '授業予定時間よりも前に授業が開始された場合' do
        it '授業終了予定時刻を返す' do
          @lesson.start!(5.minutes.ago(@lesson.start_time))
          @lesson.time_lesson_end.should == @lesson.end_time
        end
      end

      context '授業予定時間を過ぎて授業が開始された場合' do
        it '実際の授業開始時刻から授業時間経過した後の時刻を返す' do
          @lesson.start!(4.minutes.since(@lesson.start_time))
          @lesson.time_lesson_end.should == 4.minutes.since(@lesson.end_time)
        end
      end
    end

    describe "#time_to_check_lesson_extension" do
      context "授業が開始していない場合" do
        it "nilを返す" do
          @lesson.time_to_check_lesson_extension.should be_nil
        end
      end

      context "授業が開始している場合" do
        it "授業終了予定時刻の15分前を返す" do
          @lesson.start!(3.minutes.ago(@lesson.start_time))
          @lesson.time_to_check_lesson_extension.should == 15.minutes.ago(@lesson.time_lesson_end)
        end
      end
    end
  end

  describe '#cancel_by_tutor チューターがレッスンをキャンセルする' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    it "60分以上前ならキャンセル状態になる" do
      Time.stub(:now).and_return(61.minutes.ago(@lesson.start_time))
      expect {
        @lesson.cancel_by_tutor.errors.should be_empty
      }.to change{@lesson.reload.cancelled?}.from(false).to(true)
    end
  end

  describe '#cancel_by 生徒の所属BSがレッスンをキャンセルする' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
      @student = @lesson.students.first
      bs = @student.organization
      @bs_user = FactoryGirl.create(:bs_user, organization:bs)
    end

    context "成立前の場合" do
      before(:each) do
        @lesson.should be_new
      end

      it "教育コーチはいつでもキャンセルできる" do
        expect{
          @lesson.cancel_by(@bs_user)
        }.to change{@lesson.cancelled?}.from(false).to(true)
      end
    end

    context "成立後の場合" do
      before(:each) do
        @lesson.accept!
      end

      it "教育コーチはいつでもキャンセルできる" do
        Time.stub(:now).and_return(60.minutes.ago(@lesson.start_time))
        expect{@lesson.cancel_by(@bs_user)}.to change{@lesson.cancelled?}.from(false).to(true)
      end

      it "60分以内でもキャンセルできる" do
        Time.stub(:now).and_return(59.minutes.ago(@lesson.start_time))
        expect{@lesson.cancel_by(@bs_user)}.to change{@lesson.cancelled?}.from(false).to(true)
      end

      it "オプションレッスンがある月のキャンセル回数にカウントされる" do
        expect {
          @lesson.cancel_by(@bs_user)
        }.to change{BsUser.find(@bs_user.id).monthly_stats_for(@lesson.start_time.year, @lesson.start_time.month).optional_lesson_cancellation_count}.by(1)
      end
    end
  end

  describe '#ignore! レッスン申込みを無視する' do
    it "ignored?がfalseからtrueになる" do
      lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
      expect{lesson.ignore!}.to change{Lesson.find(lesson.id).ignored?}.from(false).to(true)
    end
  end

  describe '#extendable? 延長可能かどうか確認する' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    context "チューターが後にレッスンを控えている" do
      before(:each) do
        FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject,
                           students:[student],
                           start_time:20.minutes.since(@lesson.end_time))
      end

      it "延長できない" do
        @lesson.should_not be_extendable
      end
    end

    context "生徒の今月の残高が満たない場合" do
      it "延長できない" do
        student.stub(:balance_of_month).and_return(0)
        @lesson.should_not be_extendable
      end
    end
  end

  describe "#student_attended 生徒が実際に授業に参加する" do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    it "参加時刻が記録される" do
      expect {
        @lesson.student_attended(student)
      }.to change{@lesson.student_attended?(student)}.from(false).to(true)
    end
  end

  # チューター入室開始時刻に呼ばれる
  describe '#on_tutor_entry_start_time' do
    let(:lesson){FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])}

    before(:each) do
      lesson.fix!
    end

    context 'acceptされていない' do
      it 'ignoredになる' do
        expect {
          lesson.on_tutor_entry_start_time
        }.to change{lesson.ignored?}.from(false).to(true)
      end
    end
  end

  describe '#on_tutor_entry_end_time' do
    context 'レッスンが開始されていない' do
      it '授業が成立しない' do
        expect {
          accepted_lesson.on_tutor_entry_end_time
        }.not_to change{accepted_lesson.established?}.from(false)
      end

      it 'レッスンが開始されていなければお流れとなる' do
        expect {
          accepted_lesson.on_tutor_entry_end_time
        }.to change{accepted_lesson.not_started?}.from(false).to(true)
      end

    end
  end

  describe '#on_student_entry_end_time' do
  end

  describe '#on_student_entry_end_time' do
  end

  describe '#on_dropout_closing_time' do
    context 'レッスンが予定通り開始している' do
      it '授業が成立する' do
        t = accepted_lesson.start_time
        Time.stub(:now){5.minutes.ago(t)}
        accepted_lesson.start!

        expect {
          accepted_lesson.on_dropout_closing_time
        }.to change{accepted_lesson.established?}.from(false).to(true)
      end
    end

    context 'チューターが参加している' do
      before(:each) do
        accepted_lesson.tutor_entered
      end

      context '受講者が参加していない' do
        it '課金が発生する' do
          expect {
            accepted_lesson.on_dropout_closing_time
          }.to change{accepted_lesson.established?}.from(false).to(true)
        end

        it 'メールを送る' do
          Mailer.should_receive(:send_mail)
          accepted_lesson.on_dropout_closing_time
        end
      end
    end
  end

  describe "#journalize! 料金の計算をする" do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    context "established?がfalse" do
      before(:each) do
        @lesson.should_not be_established
      end

      it "取引は発生しない" do
        expect {
          @lesson.journalize!
        }.not_to change(Account::JournalEntry, :count)
      end
    end

    context "established?がtrue" do
      before(:each) do
        @lesson.establish
      end

      context "生徒がレッスンに参加した" do
        before(:each) do
          @lesson.student_attended(student)
          @lesson.attended_students.should have(1).item
        end

        context "生徒がCSレポートを書いた場合" do
          before(:each) do
            FactoryGirl.create(:cs_sheet, author:student, lesson:@lesson)
          end

          it "チューターの授業料支払仕訳が発生する" do
            expect {
              @lesson.journalize!
            }.to change(Account::OptionalLessonTutorFee, :count).by(1)
          end
        end

        context "生徒がCSレポートを書いていない場合" do
          it "チューターの授業料支払仕訳は発生する" do
            expect {
              @lesson.journalize!
            }.to change(Account::OptionalLessonTutorFee, :count).by(1)
          end
        end
      end

      context "生徒がレッスンに参加しなかった" do
        before(:each) do
          @lesson.attended_students.should be_empty
        end

        it "チューターの授業料支払仕訳が発生する" do
          expect {
            @lesson.journalize!
          }.to change(Account::OptionalLessonTutorFee, :count).by(1)
        end
      end

      #it "チューターの授業料支払仕訳が発生する" do
      #  expect {
      #    @lesson.journalize!
      #  }.to change(Account::OptionalLessonFee, :count).by(1)
      #  fee = Account::OptionalLessonFee.last
      #  fee.owner.should == student
      #end

      it "journalized_atに日付がセットされる" do
        expect {
          @lesson.journalize!
        }.to change{@lesson.journalized_at}.from(nil)
      end

      it "連続して呼んでも2回めは何も起きない" do
        @lesson.journalize!

        @lesson.should_not_receive(:journalize)
        @lesson.journalize!
      end

      it "レッスンの売上は生徒数 * (レッスン料 - 割引料）" do
        @lesson.journalize!

        @lesson.sales_amount.should == @lesson.students.inject(0){|sum, student| sum + @lesson.fee(student) - @lesson.group_lesson_discount(student)}
      end

      it "生徒に授業料支払仕訳が発生する" do
        expect {
          @lesson.journalize!
        }.to change(Account::OptionalLessonFee, :count).by(1)
      end

      #context "チューターが仮登録状態の場合" do
      #  before(:each) do
      #    tutor.should be_beginner
      #  end
      #
      #  it "仮登録チューター割引が発生する" do
      #    expect {
      #      @lesson.journalize!
      #    }.to change(Account::BeginnerTutorDiscount, :count).by(1)
      #  end
      #end

      context "同時レッスンの場合" do
        before(:each) do
          student2 = FactoryGirl.create(:student, user_name:"student2")
          tutor.anytime_available = true
          @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student, student2], start_time: 2.days.from_now, units:1)
          @lesson.establish
        end

        it "レッスンの売上は全生徒の(レッスン料 - 割引料）の和" do
          @lesson.journalize!

          @lesson.sales_amount.should == @lesson.students.inject(0){|sum, student| sum + @lesson.fee(student) - @lesson.group_lesson_discount(student)}
        end
      end
    end
  end

  describe '#tutor_not_show_up チューターがレッスンをすっぽかす' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student])
    end

    it "チューターのすっぽかしカウントが１増える" do
      expect {
        @lesson.tutor_not_show_up
      }.to change{tutor.daily_lesson_skips.count}.by(1)
    end

    it '３日すっぽかすと除籍の仕様はなくなった' do
      lesson2 = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:1.day.since(@lesson.start_time))
      lesson3 = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:2.days.since(@lesson.start_time))

      #Tutor.any_instance.should_not_receive(:expel!)
      @lesson.tutor_not_show_up
      @lesson.tutor.daily_lesson_skips.should have(1).item

      #Tutor.any_instance.should_not_receive(:expel!)
      lesson2.tutor_not_show_up
      lesson2.tutor.daily_lesson_skips.should have(2).items

      Tutor.any_instance.stub(:expel!){ raise 'should not be called' }
      lesson3.tutor_not_show_up
      lesson3.tutor.daily_lesson_skips.should have(3).items
    end

    it "３回すっぽかしても３日にわたってでなければ除籍にはならない" do
      lesson2 = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:1.hour.since(@lesson.start_time))
      lesson3 = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:2.hours.since(@lesson.start_time))

      Tutor.any_instance.should_not_receive(:expel!)
      @lesson.tutor_not_show_up

      Tutor.any_instance.should_not_receive(:expel!)
      lesson2.tutor_not_show_up

      Tutor.any_instance.should_not_receive(:expel!)
      lesson3.tutor_not_show_up

      tutor.lesson_skip_count.should == 3
    end

    describe "すっぽかし履歴を削除する" do
      it "チューターのすっぽかし回数がゼロになる" do
        lesson2 = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:1.hour.since(@lesson.start_time))
        lesson3 = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:2.hours.since(@lesson.start_time))
        @lesson.tutor_not_show_up
        lesson2.tutor_not_show_up
        lesson3.tutor_not_show_up
        tutor.lesson_skip_count.should == 3

        Tutor.clear_lesson_skip_counts

        tutor.lesson_skip_count.should == 0
      end
    end
  end

end
