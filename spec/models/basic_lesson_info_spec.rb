# encoding:utf-8
require 'spec_helper'

describe BasicLessonInfo do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:active_student)}
  let(:student2) {FactoryGirl.create(:active_student)}
  let(:now) {Time.current}
  let(:basic_lesson_info) do
    schedule = BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)
    FactoryGirl.create(:basic_lesson_info,
                       tutor:tutor,
                       students:[student],
                       schedules:[schedule])
  end

  def schedule
    BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)
  end

  def schedule2
    BasicLessonWeekdaySchedule.new(wday:(now.wday + 1) % 6, start_time:now, units:1)
  end

  describe '.create' do
    before(:each) do
      @info = FactoryGirl.build(:basic_lesson_info,
                                tutor:tutor,
                                students:[student],
                                schedules:[schedule])
    end

    it "何もパラメータを与えなくても作成できる" do
      BasicLessonInfo.new.should be_valid
    end

    it "アクティベートするときにはパラメータが揃っている必要がある" do
      expect {BasicLessonInfo.new.activate!}.to raise_error
    end

    it "パラメータが揃っていればアクティベートできる" do
      basic_lesson_info = FactoryGirl.build(:basic_lesson_info, tutor:tutor, students:[student])
      expect{basic_lesson_info.activate!}.not_to raise_error
    end

    context "確定状態時" do
      before(:each) do
        @info.save!
        @info.activate!
      end

      it "必要なパラメータが全部あればOK" do
        @info.should be_valid
      end

      it "チューターが必要" do
        @info.tutor = nil
        @info.should be_invalid
      end

      it "生徒が一人必要" do
        @info.students = []
        @info.should be_invalid
      end

      it "科目が必要" do
        @info.subject = nil
        @info.should be_valid
      end

      it "日程が１つ以上必要" do
        @info.schedules = []
        @info.should be_invalid
      end

      it "日程は2より多くなってもよい" do
        wday = (schedule.wday + 1) % 7
        @info.schedules.build(wday:wday, start_time:schedule.start_time, units:1)
        @info.should be_valid

        wday = (wday + 1) % 7
        @info.schedules.build(wday:wday, start_time:schedule.start_time, units:1)
        @info.should be_valid
      end

      it "日程はかぶってはいけない" do
        @info.schedules << BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:2)
        @info.should be_invalid
      end

      it "日程はチューターの週ごとの予定の範囲外でもよい" do
        wday = (now.wday + 1) % 7  # チューターの予定にない曜日
        @info.schedules << BasicLessonWeekdaySchedule.new(wday:wday, start_time:now, units:2)
        @info.should be_valid
      end

      context "チューターはすでに担当しているベーシックレッスンがある" do
        before(:each) do
          @info.save!
          @info.activate!
        end

        it "日程はチューターがすでに担当しているベーシックレッスンとかぶらない" do
          info = FactoryGirl.build(:basic_lesson_info, tutor:tutor, students:[student], subject:@subject)
          info.should be_invalid
        end

        it "日程は他のレッスンと１５分以上離れている必要がある" do
          info = FactoryGirl.build(:basic_lesson_info, tutor:tutor, students:[student], subject:@subject, schedules:[])

          @info.schedules.should have(1).item
          schedule = @info.schedules.first

          t1 = 14.minutes.since(schedule.end_time)
          info.schedules = [BasicLessonWeekdaySchedule.new(wday:t1.wday, start_time:t1, units:1)]
          info.should be_invalid

          t2 = 15.minutes.since(schedule.end_time)
          info.schedules = [BasicLessonWeekdaySchedule.new(wday:t2.wday, start_time:t2, units:1)]
          info.should be_valid

          t3 = (14 + 45).minutes.ago(schedule.start_time)
          info.schedules = [BasicLessonWeekdaySchedule.new(wday:t3.wday, start_time:t3, units:1)]
          info.should be_invalid

          t4 = (15 + 45).minutes.ago(schedule.start_time)
          info.schedules = [BasicLessonWeekdaySchedule.new(wday:t4.wday, start_time:t4, units:1)]
          info.should be_valid
        end
      end
    end

    describe '.conflictable_with_lesson' do
      before(:each) do
        @t = 1.hour.from_now
        schedule = BasicLessonWeekdaySchedule.new(wday: now.wday, start_time: @t, units:1)
        @basic_lesson = FactoryGirl.create(:basic_lesson_info,
                                          tutor:tutor,
                                          students:[student],
                                          schedules:[schedule])
        @basic_lesson.submit_to_tutor
      end

      it '1ヶ月以上先の同じ時間帯のレッスンはヒットする' do
        t = 5.weeks.since(@t)
        lesson = FactoryGirl.build(:optional_lesson, tutor: tutor, students: [student], start_time: t)
        BasicLessonInfo.conflictable_with_lesson(lesson).should have(1).item
      end

      it '次の締め日以前の同じ時間帯のレッスンはヒットしない' do
        t = @t
        lesson = FactoryGirl.build(:optional_lesson, tutor: tutor, students: [student], start_time: t)
        BasicLessonInfo.conflictable_with_lesson(lesson).should be_empty
      end
    end

    context '予約しようとしたい時間帯にオプションレッスンがある' do
      before(:each) do
      end

      it 'つぎの２１日以降であればバリデーションエラーになる' do
        cutoff_time = DateUtils.next_cutoff_datetime(Time.current)
        c1 = 0
        c2 = 0
        for i in (0 .. 5)
          t = 30.minutes.since(i.weeks.from_now)  # ベーシックレッスンの予定と一部重なる開始時間
          lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students: [student], start_time: t, units: 1)
          tutor.accept_lesson(lesson)
          basic_lesson_info = FactoryGirl.build(:basic_lesson_info, tutor:tutor, students:[student])
          basic_lesson_info.status = 'active'
          if t < cutoff_time
            basic_lesson_info.should be_valid
            c1 += 1
          else
            basic_lesson_info.should_not be_valid
            c2 += 1
          end
        end
        # 締め日以前と以後のそれぞれにオプションレッスンがあることを確認
        c1.should > 0
        c2.should > 0
      end
    end

    describe "コンタクトリストに変化を与える" do
      before(:each) do
        @info = FactoryGirl.build(:basic_lesson_info, tutor:tutor, students:[student], subject:@subject)
      end

      it "チューターが生徒に連絡を取れるようになる" do
        student = @info.students.first
        tutor = @info.tutor

        tutor.contact_list.count.should == 0
        student.contact_list.count.should == 0

        @info.activate!

        tutor.contact_list.count.should == 1
        tutor.contact_list.first.should == student

        student.contact_list.count.should == 1
        student.contact_list.first.should == tutor
      end
    end

    describe "確定時に開始日が自動的に決まる" do
      before(:each) do
        @info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student], subject:@subject)
        @info.start_day.should be_nil
      end

      context "現在月の２０日より前の場合" do
        it "現在の翌月１日が開始日となる" do
          Time.stub(:now).and_return(Time.new(now.year, now.month, 20, now.hour, now.min))

          @info.activate!
          @info.start_day.should be_present
          @info.start_day.year == now.year
          @info.start_day.month == now.month + 1
        end
      end

      context "現在月の２１日以降の場合" do
        it "現在の翌々月１日が開始日となる" do
          Time.stub(:now).and_return(Time.new(now.year, now.month, 21, now.hour, now.min))

          @info.activate!
          @info.start_day.should be_present
          @info.start_day.year == now.year
          @info.start_day.month == now.month + 2
        end
      end
    end
  end

  describe "期間を指定してレッスンを作成する create_lessons(from, to)" do
    before(:each) do
      @info = FactoryGirl.create(:basic_lesson_info,
                                 tutor:tutor,
                                 students:[student],
                                 schedules:[schedule])
    end

    it "指定した期日まで授業を作成する" do
      lessons = @info.create_lessons(Date.tomorrow, 28.days.since(Date.today))
      lessons.should have(4).items
      lessons.all?{|l| l.start_time.wday == now.wday}.should be_true
    end

    it "作成された授業とひもづけられる" do
      lessons = @info.create_lessons(Date.tomorrow, 28.days.since(Date.today))
      lessons.all?{|l| l.course == @info}.should be_true
    end
  end

  describe '#create_lessons_of_month(year, month)' do
    before(:each) do
      @info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student], subject:@subject, schedules:[schedule])
      @next_month = 1.month.from_now
    end

    it "指定した月の授業データを作成する" do
      lessons = @info.create_lessons_of_month!(@next_month.year, @next_month.month)
      lessons.should be_a(Array)
      lessons.each do |lesson|
        lesson.should be_a(BasicLesson)
      end
      lessons.count.should >= 4
    end

    it '同じ月に複数回実行しても、2回目は新しく作成されない' do
      expect {
        @info.create_lessons_of_month!(@next_month.year, @next_month.month)
      }.to change(BasicLesson, :count)
      expect {
        @info.create_lessons_of_month!(@next_month.year, @next_month.month)
      }.not_to change(BasicLesson, :count)
    end
  end

  describe "#extend_months(months=1)" do
    before(:each) do
      @today = Date.today
    end

    it "ベーシックレッスンを現在存在する分から一ヶ月分追加する" do
      Date.stub(:today).and_return(Date.new(@today.year, @today.month, 20))

      info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, subject:@subject, students:[student])
      days = DateUtils.days_of_month(1.month.from_now)
      lesson_count = info.schedules.map(&:wday).inject(0){|c, wday| c + days.select{|d| d.wday == wday}.size}
      lesson_count.should >= 4
      expect {
        info.extend_months
      }.to change{BasicLesson.of_month(1.month.from_now).count}.by(lesson_count)
    end

    it "21日を過ぎていれば２ヶ月後に追加される" do
      Date.stub(:today).and_return(Date.new(@today.year, @today.month, 21))

      info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, subject:@subject, students:[student])
      n = 2
      days = DateUtils.days_of_month(n.month.from_now)
      lesson_count = info.schedules.map(&:wday).inject(0){|c, wday| c + days.select{|d| d.wday == wday}.size}
      lesson_count.should >= 4
      expect {
        info.extend_months
      }.to change{BasicLesson.of_month(n.month.from_now).count}.by(lesson_count)
    end

    it "n回続けるとnヶ月先まで予定が埋められる" do
      Date.stub(:today).and_return(Date.new(@today.year, @today.month, 20))
      n = 3
      info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, subject:@subject, students:[student])
      days = DateUtils.days_of_month(n.month.from_now)
      lesson_count = info.schedules.map(&:wday).inject(0){|c, wday| c + days.select{|d| d.wday == wday}.size}
      lesson_count.should >= 4
      expect {
        n.times{ info.extend_months }
      }.to change{BasicLesson.of_month(n.month.from_now).count}.by(lesson_count)
    end

    #it "3ヶ月先までしか予定を埋められない" do
    #  Date.stub(:today).and_return(Date.new(@today.year, @today.month, 20))
    #  info = FactoryGirl.create(:basic_lesson_info_with_a_student)
    #  info.extend_months(4)
    #end
  end

  describe 'close_at! ベーシックレッスンの終了日をセットする' do
    it "final_dayがセットされる" do
      expect {
        basic_lesson_info.close_at!(1.month.from_now.to_date.end_of_month)
      }.to change{basic_lesson_info.final_day.present?}.from(false).to(true)
    end

    it "指定した日にち以降に授業が登録されているとエラー" do
      basic_lesson_info.extend_months(2)
      expect {
        basic_lesson_info.close_at!(Time.now.end_of_month)
      }.to raise_error

      basic_lesson_info.close_at!(Time.now.end_of_month){ false }.should be_false
    end

    it "強制フラグを立てていれば、レッスンが残っている場合それらをキャンセルする" do
      basic_lesson_info.extend_months(2)
      expect {
        basic_lesson_info.close_at!(Time.now.end_of_month, force:true)
      }.not_to raise_error

      basic_lesson_info.lessons.each do |lesson|
        lesson.should be_cancelled
      end
    end
  end

  describe "レッスンの支払を確定する" do
    pending "仕様が未確定"
  end


  describe '終了月を設定する stop_in_month(year, month)' do
    before(:each) do
      now = Time.now
    end

    context "現在が20日かそれ以前" do
      before(:each) do
        t = Time.new(now.year, now.month, 20)
        Time.stub(:now).and_return(t)
        Date.stub(:today).and_return(t.to_date)
      end

      describe "今月で終了する" do
        before(:each) do
          @last_day = DateUtils.cutoff_date_of_month(now)
        end

        it "成功する" do
          basic_lesson_info.stop_in_month(now.year, now.month).should be_true
        end

        it "終了日が今月末が設定される" do
          expect {
            basic_lesson_info.stop_in_month(now.year, now.month).should be_true
          }.to change{basic_lesson_info.final_day}.from(nil).to(@last_day)
        end

        context "来月以降のレッスンがある" do
          before(:each) do
            basic_lesson_info.supply_lessons # 来月以降のレッスンデータが作成される
            basic_lesson_info.lessons.should be_present
          end

          it "それらのレッスンはキャンセルされる" do
            expect {
              basic_lesson_info.stop_in_month(now.year, now.month)
            }.to change{basic_lesson_info.lessons.reload.empty?}.from(false).to(true)
          end
        end
      end

      it "先月で終了にはできない" do
        month = now.prev_month
        basic_lesson_info.stop_in_month(month.year, month.month).should be_false
      end
    end

    context "現在が21日以降" do
      before(:each) do
        t = Time.new(now.year, now.month, SystemSettings.cutoff_date + 1)
        Time.stub(:now).and_return(t)
        Date.stub(:today).and_return(t.to_date)
      end

      it "今月で終了にはできない" do
        basic_lesson_info.stop_in_month(now.year, now.month).should be_false
      end

      it "先月分はキャンセルできない" do
        month = now.prev_month
        basic_lesson_info.stop_in_month(month.year, month.month).should be_false
      end

      it "来月で終了にはできる" do
        month = now.next_month
        basic_lesson_info.stop_in_month(month.year, month.month).should be_true
      end
    end


    it "final_dayフィールドが終了月翌月の1日に設定される" do

    end

    it "終了月以降のレッスンはキャンセルされる"
  end

  describe '#supply_lessons' do
    it 'レッスンデータを作成する' do
      basic_lesson_info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student], schedules:[schedule])
      basic_lesson_info.lessons.should be_empty
      basic_lesson_info.supply_lessons
      basic_lesson_info.lessons.should_not be_empty
    end

    it '次の締め日翌日以降からレッスンを入れる' do
      basic_lesson_info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student], schedules:[schedule])
      basic_lesson_info.supply_lessons
      basic_lesson_info.lessons.all?{|lesson| lesson.start_time >= DateUtils.next_cutoff_datetime(Time.now)}.should be_true
      basic_lesson_info.lessons.any?{|lesson| lesson.start_time < DateUtils.next_cutoff_datetime(1.month.from_now)}.should be_true
    end

    it '4ヶ月後の次の締め日までのレッスンを入れる' do
      basic_lesson_info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student], schedules:[schedule])
      basic_lesson_info.supply_lessons
      basic_lesson_info.lessons.all?{|lesson| lesson.start_time < DateUtils.cutoff_datetime_of_month(4.months.from_now)}.should be_true
      basic_lesson_info.lessons.any?{|lesson| lesson.start_time >= DateUtils.cutoff_datetime_of_month(3.months.from_now)}.should be_true
    end

    context 'すでに一度実行されている' do
      before(:each) do
        @basic_lesson_info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student], schedules:[schedule])
        @basic_lesson_info.supply_lessons
      end
      it '変化しない' do
        expect {
          @basic_lesson_info.supply_lessons
        }.not_to change{@basic_lesson_info.lessons.count}
      end

      it 'レッスンが欠けている場合はそれを補充する' do
        @basic_lesson_info.lessons.first.destroy.should be_true
        expect {
          @basic_lesson_info.supply_lessons
        }.to change{@basic_lesson_info.lessons.count}.by(1)
      end

      it 'レッスンがキャンセルされている場合は特に変化しない' do
        lesson = @basic_lesson_info.lessons.first
        lesson.cancel
        Lesson.find(lesson.id).should be_cancelled
        expect {
          @basic_lesson_info.supply_lessons
        }.not_to change{@basic_lesson_info.lessons.count}
      end
    end
  end

  describe "【定期タスク】ベーシックレッスンのデータを３ヶ月先まで補充する" do
    before(:each) do
      @info = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student], subject:@subject, schedules:[schedule])
      @info.activate!
    end

    it "アクティブなベーシックレッスンにレッスンを補充する" do
      @info.lessons.should be_empty
      BasicLessonInfo.supply_lessons
      BasicLessonInfo.find(@info.id).lessons.should_not be_empty
    end

    it "4ヶ月先まで補充する" do
      @info.lessons.should be_empty
      BasicLessonInfo.supply_lessons
      d = DateUtils.cutoff_datetime_of_month(4.months.from_now)
      @info.reload.lessons.last.start_time.should < d
      @info.reload.lessons.last.start_time.should > 8.day.ago(d)
    end
  end

  describe '同じチューターに、重複する時間帯のベーシックレッスンを申し込む' do
    before do
      @basic_lesson2 = FactoryGirl.create(:basic_lesson_info,
                                          tutor:tutor,
                                          students:[student2],
                                          schedules:[schedule])
      @basic_lesson2.submit_to_tutor
      @basic_lesson2.should be_pending
    end

    it '別の生徒であれば同じ時間に予約できる' do
      info = FactoryGirl.build(:basic_lesson_info,
                               tutor:tutor,
                               students:[student],
                               schedules:[schedule])
      info.should be_valid
    end

    it '同じ生徒は重複する時間に申込できない' do
      info = FactoryGirl.build(:basic_lesson_info,
                               tutor:tutor,
                               students:[student2],
                               schedules:[schedule])
      info.should be_invalid
    end

    describe '時間の重複した申込みから一つを承諾する' do
      it '残りのベーシックレッスンは拒否される' do
        info = FactoryGirl.create(:basic_lesson_info,
                                  tutor:tutor,
                                  students:[student],
                                  schedules:[schedule, schedule2])
        info.submit_to_tutor
        expect {
          info.accept
        }.to change{BasicLessonInfo.find(@basic_lesson2.id).rejected?}.from(false).to(true)
      end
    end
  end

  describe 'extend!' do
    before(:each) do
      basic_lesson_info.accept
    end

    context '自動延長がオフになっている' do
      before(:each) do
        basic_lesson_info.turn_off_auto_extension
      end

      it 'レッスンは増えない' do
        n1 = basic_lesson_info.lessons.count
        BasicLessonInfo.extend!(now.year, now.month)
        n2 = basic_lesson_info.reload.lessons.count
        n2.should == n1
      end
    end

    context '自動延長がオンになっている' do
      before(:each) do
        basic_lesson_info.turn_on_auto_extension
      end

      it 'レッスンが増える' do
        n1 = basic_lesson_info.lessons.count
        BasicLessonInfo.extend!(now.year, now.month)
        n2 = basic_lesson_info.reload.lessons.count
        n2.should > n1
      end
    end
  end
end
