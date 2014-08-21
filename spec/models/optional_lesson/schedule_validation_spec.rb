# encoding:utf-8
require 'spec_helper'

describe OptionalLesson do
  disconnect_sunspot

  let(:subject) {FactoryGirl.create(:subject)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:tutor2) {FactoryGirl.create(:tutor, user_name: 'tutor2')}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:student, organization:bs)}
  let(:student2) {FactoryGirl.create(:student)}

  before(:each) do
    OptionalLesson.any_instance.stub(:should_validate_schedule?){true} # バリデーションを有効化
  end

  describe '日程の制約' do
    before(:each) do
      @lesson = FactoryGirl.build(:optional_lesson, tutor:tutor, students:[student])
      t1 = @lesson.start_time
      t2 = 1.hours.since(@lesson.end_time)
      tutor.daily_available_times.create!(start_at: t1, end_at: t2)
    end

    context '同じ時間帯に同じチューターが担当する別のレッスンがある場合' do
      context 'オプションレッスンの場合' do
        before(:each) do
          @lesson2 = FactoryGirl.create(:optional_lesson,
                                        tutor:tutor,
                                        students:[student2],
                                        start_time:@lesson.start_time)
        end

        context 'そのレッスンが申込中の場合' do
          it '同じ時間帯に申し込むことができる' do
            @lesson.should be_valid
          end
        end

        context 'そのレッスンが開催確定の場合' do
          before(:each) do
            @lesson2.accept!
          end

          it "レッスンは作成できない" do
            @lesson.should_not be_valid
          end
        end
      end

      context 'ベーシックレッスンの場合' do
        let(:basic_lesson_info) do
          schedule = BasicLessonWeekdaySchedule.new(wday: @lesson.start_time.wday, start_time: @lesson.start_time, units:1)
          @basic_lesson = FactoryGirl.create(:basic_lesson_info,
                                             tutor: tutor,
                                             students: [student],
                                             schedules: [schedule])
        end

        context '申込中の場合' do
          before(:each) do
            basic_lesson_info.submit_to_tutor
            basic_lesson_info.should be_pending
          end

          it '時間帯が重なるベーシックレッスンがあると申し込めない' do
            BasicLessonInfo.stub(:conflictable_with_lesson){[@basic_lesson]}
            @lesson.should_not be_valid
            p @lesson.errors.full_messages
          end

          it 'ベーシックレッスンの申し込みが前の月だと同じ時間帯に申し込めない' do
            BasicLessonInfo.stub(:conflictable_with_lesson){[]}
            @lesson.should be_valid
            p @lesson.errors.full_messages
          end
        end

        context '確定済みの場合' do
          before(:each) do
            basic_lesson_info.submit_to_tutor
            basic_lesson_info.accept
            basic_lesson_info.should be_active
          end

          it '個別のレッスン日程にかぶらなければ作成できる' do
            basic_lesson_info.lessons.should be_empty
            @lesson.should be_valid
          end
        end
      end
    end

    context '同じ時間帯に同じ生徒が受講する別のレッスンがある場合' do
      before(:each) do
        t1 = 2.hours.ago(@lesson.start_time)
        t2 = 2.hours.since(@lesson.end_time)
        tutor2.daily_available_times.create!(start_at: t1, end_at: t2)
      end

      it "レッスンは作成できない" do
        lesson2 = FactoryGirl.create(:optional_lesson,
                                     tutor:tutor2,
                                     students:[student],
                                     start_time:@lesson.start_time)
        @lesson.should_not be_valid
      end

      it "15分前に終るレッスンは問題ない" do
        t = 60.minutes.ago(@lesson.start_time)
        lesson2 = FactoryGirl.create(:optional_lesson,
                                     tutor:tutor2,
                                     students:[student],
                                     start_time:t)
        15.minutes.since(lesson2.end_time).should == @lesson.start_time

        @lesson.should be_valid
      end

      it "14分前に終るレッスンとは衝突する" do
        t = 59.minutes.ago(@lesson.start_time)
        lesson2 = FactoryGirl.create(:optional_lesson,
                                     tutor:tutor2,
                                     students:[student],
                                     start_time:t)
        14.minutes.since(lesson2.end_time).should == @lesson.start_time

        @lesson.should_not be_valid
      end

      it "15分後にはじまるレッスンは問題ない" do
        t = 15.minutes.since(@lesson.end_time)
        lesson2 = FactoryGirl.create(:optional_lesson,
                                     tutor:tutor2,
                                     students:[student],
                                     start_time:t)
        15.minutes.ago(lesson2.start_time).should == @lesson.end_time

        @lesson.should be_valid
      end

      it "14分後にはじまるレッスンとは衝突する" do
        t = 14.minutes.since(@lesson.end_time)
        lesson2 = FactoryGirl.create(:optional_lesson,
                                     tutor:tutor2,
                                     students:[student],
                                     start_time:t)
        14.minutes.ago(lesson2.start_time).should == @lesson.end_time

        @lesson.should_not be_valid
      end
    end

    describe '複数単位数のレッスンを登録する' do
      it '2コマ予約すると終了時刻は95分後になる' do
        lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:2.hours.from_now, units:2)
        lesson.end_time.should == 95.minutes.since(lesson.start_time)
      end
    end

    context 'チューターが指導可能な時間帯を登録している場合' do
      before(:each) do
        tutor.daily_available_times.should have(1).item
        @start_time = @lesson.start_time
        @end_time   = 1.hour.since(@start_time)
      end

      it '範囲外の時間を申し込めない' do
        lesson = FactoryGirl.build(:optional_lesson, tutor: tutor, students:[student],
                                   start_time: 1.minute.ago(@start_time), units: 1)
        lesson.should be_invalid
      end

      it '範囲内の時間であれば申し込める' do
        lesson = FactoryGirl.build(:optional_lesson, tutor: tutor, students:[student], start_time: @start_time, units: 1)
        lesson.should be_valid
        lesson = FactoryGirl.build(:optional_lesson, tutor: tutor, students:[student], start_time: Lesson.duration_per_unit.minutes.ago(@end_time), units: 1)
        lesson.should be_valid
      end

      it '申込み後に当該の日程を削除しても承認できる' do
        lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students:[student], start_time: @start_time, units: 1)
        tutor.daily_available_times.destroy_all
        lesson.accept!
      end
    end

    context 'チューターの週スケジュールが指定されている場合' do
      it 'その時間帯以外でもオプションレッスンを登録できる' do
        t1 = 1.day.from_now
        t2 = 1.hour.since t1
        tutor.daily_available_times.create!(start_at: 1.minute.ago(t1), end_at: t2)
        tutor.weekday_schedules.create!(start_time: t1, end_time: t2)
        tutor.reload
        lesson = FactoryGirl.build(:optional_lesson, tutor: tutor, students:[student], start_time: 1.minute.ago(t1), units: 1)
        lesson.should be_valid
      end
    end
  end
end
