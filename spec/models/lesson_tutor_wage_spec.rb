# coding:utf-8
require 'spec_helper'

describe LessonTutorWage do
  let(:tutor) {FactoryGirl.create :tutor}
  let(:student) {FactoryGirl.create :student}
  let(:student2) {FactoryGirl.create :student}
  let(:lesson) {FactoryGirl.create :optional_lesson, tutor: tutor, students: [student]}
  let(:shared_lesson) {FactoryGirl.create :shared_optional_lesson, tutor: tutor, students: [student, student2]}

  subject{lesson.create_lesson_tutor_wage}

  describe 'creation' do
    it 'レッスンが作る' do
      lesson.create_lesson_tutor_wage.should be_valid
    end
  end

  describe 'wage' do
    context '通常レッスンの場合' do
      it 'レッスンの報酬額を返す' do
        subject.wage.should == lesson.tutor_base_wage
      end

      context '延長した場合' do
        before(:each) do
          Student.any_instance.stub(:can_pay_lesson_extension_fee?).and_return(true)
          lesson.student_attended student
          lesson.tutor_attended
          lesson.should be_started
          lesson.create_extension_request(student).should be_persisted
          extension = lesson.extend!
          extension.should be_persisted
        end

        it '延長分を含む' do
          subject.wage.should be > lesson.tutor_base_wage
          subject.includes_extension_wage.should be_true
          subject.wage.should == (lesson.tutor_base_wage * (30 + 45) / 45).to_i
        end
      end
    end

    context '同時レッスンの場合' do
      subject{shared_lesson.create_lesson_tutor_wage}

      it '増額する' do
        subject.wage.should be > shared_lesson.tutor_base_wage
      end

      it '2割増' do
        subject.wage.should == (shared_lesson.tutor_base_wage * 1.2).to_i
      end

      context '延長した場合' do
        before(:each) do
          Student.any_instance.stub(:can_pay_lesson_extension_fee?).and_return(true)
          shared_lesson.student_attended student
          shared_lesson.student_attended student2
          shared_lesson.tutor_attended
          shared_lesson.should be_started
          shared_lesson.create_extension_request(student).should be_persisted
          shared_lesson.create_extension_request(student2).should be_persisted
          extension = shared_lesson.extend!
          extension.should be_persisted
        end

        it '延長分を含む' do
          subject.wage.should be > shared_lesson.tutor_base_wage
          subject.includes_extension_wage.should be_true
          subject.wage.should == ((shared_lesson.tutor_base_wage * (30 + 45) / 45).to_i * 1.2).to_i
        end
      end
    end
  end

  describe '#total_wage' do
    it '税金を含む' do
      subject.total_wage.should == (subject.wage * 1.05).to_i
    end
  end

  describe 'includes_group_lesson_premium?' do
    context '通常レッスンの場合' do
      it '通常レッスンの場合はfalseを返す' do
        subject.includes_group_lesson_premium.should be_false
      end
    end

    context '同時レッスンの場合' do
      subject{shared_lesson.create_lesson_tutor_wage}

      it '同時レッスンの場合はtrueを返す' do
        subject.includes_group_lesson_premium.should be_true
      end
    end
  end

  describe '#journalize' do
    it '仕訳オブジェクトを返す' do
      journal_entry = subject.journalize
      journal_entry.should be_persisted
    end

    it 'Account::JounalEntryが１つ増える' do
      expect {
        subject.journalize
      }.to change(Account::JournalEntry, :count).by(1)
    end

    context 'レッスンがオプションレッスンの場合' do
      it 'Account::OptionalLessonTutorFeeが１つ増える' do
        expect {
          subject.journalize
        }.to change(Account::OptionalLessonTutorFee, :count).by(1)
      end
    end

    it '所有者はチューター' do
      journal_entry = subject.journalize
      journal_entry.owner.should == tutor
    end

    it '支払金額はゼロ' do
      journal_entry = subject.journalize
      journal_entry.amount_of_payment.should == 0
    end

    it '受取金額は「税抜き」の賃金額に等しい' do
      journal_entry = subject.journalize
      journal_entry.amount_of_money_received.should == subject.wage
    end

    it '#journalized?がtrueになる' do
      expect {
        subject.journalize.should be_valid
      }.to change{subject.journalized?}.from(false).to(true)
    end

    context 'CSシートが出揃っていない場合' do
      before(:each) do
        lesson.student_attended(student)
        lesson.tutor_attended
        lesson.should be_started
        lesson.class.any_instance.stub(:cs_sheets_collected?){false}
      end

      it '仕分けデータは作られる' do
        expect {
          subject.journalize.should be_valid
        }.to change(Account::JournalEntry, :count).by(1)
      end

      it 'journalized?はtrueになる' do
        expect {
          subject.journalize.should be_valid
        }.to change{subject.journalized?}.from(false).to(true)
      end
    end

    context '仕訳データが作られなかった場合' do
      it '#journalized?=falseのまま' do
        entry = mock_model(Account::OptionalLessonTutorFee)
        subject.lesson.class.any_instance.stub(:create_lesson_tutor_fee){entry}
        entry.stub(:persisted?){false}

        expect {
          subject.journalize
        }.not_to change{subject.journalized?}.from(false)
      end
    end
  end

end
