# coding:utf-8

require 'spec_helper'

describe LessonAccounting do
  let(:tutor) {FactoryGirl.create :tutor}
  let(:student) {FactoryGirl.create :student}
  let(:student2) {FactoryGirl.create :student}
  let(:lesson) {FactoryGirl.create :optional_lesson, tutor: tutor, students: [student]}
  let(:shared_lesson) {FactoryGirl.create :shared_optional_lesson, tutor: tutor, students: [student, student2]}

  describe '#journalize' do
    context 'レッスンが課金対象の場合' do
      subject {LessonAccounting.new(lesson)}
      
      before(:each) do
        lesson.establish
        lesson.student_attended(student)
        lesson.tutor_attended
        lesson.should be_started
        lesson.close.should be_valid
      end

      context 'CSシートが揃っている場合' do
        before(:each) do
          lesson.class.any_instance.stub(:cs_sheets_collected?){true}
        end

        it 'チューターの賃金が作られる' do
          expect {
            subject.journalize!
          }.to change(LessonTutorWage, :count).by(1)
        end

        it 'チューターの賃金仕訳が作られる' do
          expect {
            subject.journalize!
          }.to change(Account::OptionalLessonTutorFee, :count).by(1)
        end

        it '会計処理が完了する' do
          expect {
            subject.journalize!
          }.to change{lesson.accounting_status}.from('unprocessed').to('processed')
        end

        context '通常レッスンの場合' do
          it '受講者の支払データが作られる' do
            expect {
              subject.journalize!
            }.to change(LessonCharge, :count).by(1)
          end

          it '受講者の支払データが作られる' do
            expect {
              subject.journalize!
            }.to change(Account::OptionalLessonFee, :count).by(1)
          end
        end

        describe '複数回呼ぶ' do
          it 'チューターの賃金は１つ増える' do
            expect {
              subject.journalize!
              subject.journalize!
            }.to change(LessonTutorWage, :count).by(1)
          end

          it '受講者の支払データは１つ増える' do
            expect {
              subject.journalize!
              subject.journalize!
            }.to change(LessonCharge, :count).by(1)
          end
        end
      end

      context 'CSシートが揃っていない場合' do
        before(:each) do
          lesson.class.any_instance.stub(:cs_sheets_collected?){false}
        end

        it '会計処理は完了する' do
          expect {
            subject.journalize!
          }.to change{lesson.accounting_status}.from('unprocessed').to('processed')
        end
      end
    end

    context '同時レッスンの場合' do
      context 'レッスンが課金対象になっている場合' do
        before(:each) do
          shared_lesson.establish
        end

        subject {LessonAccounting.new(shared_lesson)}

        it '受講者の支払データが人数分作られる' do
          expect {
            subject.journalize!
          }.to change(LessonCharge, :count).by(2)
        end

        it '受講者の支払データが人数分作られる' do
          expect {
            subject.journalize!
          }.to change(Account::OptionalLessonFee, :count).by(2)
        end
      end
    end
  end

  describe '#clear_journal_entries' do
    context '会計処理済' do
      before(:each) do
        lesson.establish
        lesson.student_attended(student)
        lesson.tutor_attended
        lesson.should be_started
        lesson.close.should be_valid
        lesson.class.stub(:cs_sheets_collected?){true}
        lesson.journalize!
        lesson.should be_journalized
      end

      subject {LessonAccounting.new(lesson)}

      it '会計データがなくなる' do
        expect {
          subject.clear_journal_entries
        }.to change{Lesson.find(lesson.id).journal_entries.empty?}.from(false).to(true)
      end

      it 'チューター賃金データがなくなる' do
        expect {
          subject.clear_journal_entries
        }.to change{Lesson.find(lesson.id).lesson_tutor_wage.present?}.from(true).to(false)
      end

      it '受講者の請求データがなくなる' do
        expect {
          subject.clear_journal_entries
        }.to change{Lesson.find(lesson.id).lesson_charges.present?}.from(true).to(false)
      end
    end
  end
end
