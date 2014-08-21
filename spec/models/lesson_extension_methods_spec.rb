# coding:utf-8
require 'spec_helper'

describe LessonExtensionMethods do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:student, organization:bs)}
  let(:student2) {FactoryGirl.create(:student)}

  describe '#extendable?' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student])
    end

    context "チューターが後にレッスンを控えている" do
      before(:each) do
        FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student2],
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

  describe '#request_extension' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student])
    end

    context 'レッスン開催中' do

    end

    context 'お金が足りない' do
      before(:each) do
        Student.any_instance.stub(:can_pay_lesson_extension_fee?).and_return(false)
      end

      it '延長を申し込めない' do
        application = @lesson.create_extension_request(student)
        application.should_not be_persisted
      end
    end

    context 'お金は足りている' do
      before(:each) do
        Student.any_instance.stub(:can_pay_lesson_extension_fee?).and_return(true)
      end

      context 'チューターのスケジュールが詰まっている' do
        before(:each) do
          FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student2],
                             start_time:20.minutes.since(@lesson.end_time))
        end

        it '延長を申し込めない' do
          extension = @lesson.create_extension_request(student)
          extension.should_not be_persisted
        end
      end

      context 'チューターのスケジュールも空いている' do
        it '受講者が延長を申し込んだ状態になる' do
          extension = @lesson.create_extension_request(student)
          extension.should be_persisted
        end

        it '延長申込データが増える' do
          expect {
            @lesson.create_extension_request(student)
          }.to change(LessonExtensionRequest, :count).by(1)
        end

        it '同じ生徒が複数回申し込んでも１つしか増えない' do
          expect {
            @lesson.create_extension_request(student)
          }.to change(LessonExtensionRequest, :count).by(1)
          expect {
            @lesson.create_extension_request(student)
          }.not_to change(LessonExtensionRequest, :count)
        end
      end

      context 'チューターはスケジュールが入っているが、十分な時間が空いている' do
        before(:each) do
          FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student2],
                             start_time:50.minutes.since(@lesson.end_time))
        end

        it '受講者が延長を申し込んだ状態になる' do
          extension = @lesson.create_extension_request(student)
          extension.should be_persisted
        end
      end
    end
  end

  describe '#extend' do

    context '開催中＆参加者あり' do
      before(:each) do
        Student.any_instance.stub(:can_pay_lesson_extension_fee?).and_return(true)
        @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student])
        @lesson.start!
        @lesson.students.each do |student|
          @lesson.student_attended(student)
        end
      end

      context '全員延長申込済' do
        before(:each) do
          @lesson.students.each do |student|
            @lesson.create_extension_request(student).should be_persisted
          end
        end

        it '延長確定する' do
          lesson_extension = @lesson.extend!
          lesson_extension.should be_persisted
        end

        it 'on_extendedが呼ばれる' do
          @lesson.class.any_instance.should_receive(:on_extended)
          @lesson.extend!
        end

        it 'reset_closing_processが呼ばれる' do
          @lesson.class.any_instance.should_receive(:reset_closing_process)
          @lesson.extend!
        end

        it 'レッスンの終了時間が30分延びる' do
          expect {
            @lesson.extend!
          }.to change{Lesson.find(@lesson.id).time_lesson_end}.by(30.minutes)
        end

        it 'extended?がtrueになる' do
          expect{
            @lesson.extend!
          }.to change{Lesson.find(@lesson.id).extended?}.from(false).to(true)
        end

        context 'レッスン終了' do
          before(:each) do
            @lesson.class.any_instance.stub(:status){'done'}
          end

          it '延長できないしない' do
            lesson_extension = @lesson.extend!
            lesson_extension.should_not be_persisted
          end
        end
      end

      context '全員延長申込ではない' do
        it '延長できない' do
          lesson_extension = @lesson.extend!
          lesson_extension.should_not be_persisted
        end
      end
    end
  end
end