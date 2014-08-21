# coding:utf-8
require 'spec_helper'

describe SharedBasicLessonInfo do

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student)}
  let(:student2) {FactoryGirl.create(:student)}
  let(:now) {Time.current}

  subject {FactoryGirl.create(:shared_basic_lesson_info,
                              tutor:tutor,
                              students:[student, student2],
                              schedules:[schedule])}

  def schedule
    BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)
  end

  def schedule2
    BasicLessonWeekdaySchedule.new(wday:(now.wday + 1) % 6, start_time:now, units:1)
  end

  describe '作成する' do
    it '受講者二人で作成する' do
      info = FactoryGirl.create(:shared_basic_lesson_info, tutor:tutor, students:[student, student2], schedules:[schedule])
      info.should be_shared_lesson
      info.should_not be_friends_lesson
    end
  end

  describe 'レッスンデータを作成する' do
    it '作成されたデータは同時レッスン' do
      lessons = subject.supply_lessons
      lessons.should_not be_empty
      lessons.each do |lesson|
        lesson.should be_shared_lesson
      end
      lessons.each do |lesson|
        lesson.style.should eq(:shared)
      end
    end
  end

  describe '#add_student' do
    context '空きがある場合' do
      subject {FactoryGirl.create(:shared_basic_lesson_info,
                                  tutor:tutor,
                                  students:[student],
                                  schedules:[schedule])}

      it '参加受講者が増える' do
        expect {
          subject.add_student(student2).should be_valid
        }.to change{BasicLessonInfo.find(subject.id).students.count}.by(1)
      end

      it '同じ受講者は追加できない' do
        subject.add_student(student).should_not be_persisted
      end

      #it '同じ受講者を追加しても人数は増えない' do
      #  Rails.logger.debug '--------------------------------------------------- 1'
      #  subject
      #  expect {
      #    subject.add_student(student).should be_persisted
      #  }.not_to change(BasicLessonStudent, :count)
      #  Rails.logger.debug '--------------------------------------------------- 2'
      #end

      describe '既存のレッスンへの割り当て' do
        before(:each) do
          @now = Time.current

          # 来月にレッスンが存在するように、一時的に締め日前とする
          #Time.stub(:now){@now.change(day: SystemSettings.cutoff_date)}

          subject.supply_lessons
        end

        context '現在締め日前' do
          before(:each) do
            @today = subject.lessons.first.start_time.change(day: SystemSettings.cutoff_date)
            Time.stub(:now){@today}
          end

          it '追加した受講者のレッスンが増える' do
            expect {
              subject.add_student(student2).should be_persisted
            }.to change{student2.lessons.reload.count}
          end

          it '来月の授業から参加する' do
            subject.add_student(student2).should be_persisted

            lessons = subject.lessons.where('start_time >= ?', @today.next_month.beginning_of_month)
            lessons.should be_present
            lessons.each do |lesson|
              lesson.students.reload.include?(student2).should be_true
            end
          end
        end

        context '現在締め日後' do
          before(:each) do
            @today = subject.lessons.first.start_time.change(day: SystemSettings.cutoff_date + 1)
            Time.stub(:now){@today}
          end

          it '再来月の授業から参加する' do
            subject.add_student(student2).should be_persisted

            lessons = subject.lessons.where('start_time <= ?', @today.next_month.end_of_month)
            lessons.should be_present
            lessons.each do |lesson|
              lesson.students.reload.include?(student2).should be_false
            end

            lessons = subject.lessons.where('start_time >= ?', 2.months.since(@today).beginning_of_month)
            lessons.should be_present
            lessons.each do |lesson|
              lesson.students.reload.include?(student2).should be_true
            end
          end
        end
      end
    end

    context '空きがない場合' do
      subject {FactoryGirl.create(:shared_basic_lesson_info,
                                  tutor:tutor,
                                  students:[student, student2],
                                  schedules:[schedule])}

      it '参加者は増やせない' do
        student3 = FactoryGirl.create(:student)
        subject.add_student(student3).should_not be_persisted
        subject.add_student(student3).errors[:student].should have(1).item
      end

      it '[受講者はこのレッスンに参加できません]というエラーメッセージを含む' do
        student3 = FactoryGirl.create(:student)
        subject.add_student(student3).errors.full_messages.should == ['受講者はこのレッスンに参加できません。']
      end
    end
  end
end
