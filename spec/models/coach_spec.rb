# coding:utf-8
require 'spec_helper'

describe Coach do
  subject{FactoryGirl.create(:coach)}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:active_student)}

  describe '作成' do
    it '必要なパラメータがあればOK' do
      FactoryGirl.build(:coach).should be_valid
    end

    it '組織が要る' do
      FactoryGirl.build(:coach, organization: nil).should_not be_valid
    end

    it 'デフォルトでアクティブ' do
      FactoryGirl.create(:coach).should be_active
    end

    it '重複するニックネームはダメ' do
      FactoryGirl.create(:coach, nickname: 'hoge').should be_valid
      FactoryGirl.build(:coach, nickname: 'hoge').should_not be_valid
    end

    it 'BSアカウントと同じニックネームはOK' do
      FactoryGirl.create(:bs_user, nickname: 'hoge').should be_valid
      FactoryGirl.build(:coach, nickname: 'hoge').should be_valid
    end
  end

  describe '#destroy' do
    context '受講者とひもづけられている場合' do
      before(:each) do
        subject.students << student
      end

      it '削除できない' do
        expect {
          subject.destroy
        }.not_to change(Coach, :count)
      end

      it 'エラーが追加される' do
        subject.destroy
        subject.errors.should be_present
        subject.errors.full_messages.should == ['指導中の受講者がいます。']
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
      Student.find(student.id).coach.should == subject
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

  describe '#bs_students' do
    before(:each) do
      bs = subject.organization
      @student2 = FactoryGirl.create(:student, organization: bs)
      subject.students.include?(@student2).should be_false
      student.organization = bs
      student.save!
      bs.reload.students.should have(2).items
    end

    it 'コーチが所属する受講生を返す' do
      subject.assign_student(student)

      subject.students.should have(1).item
      subject.bs_students.should have(2).item
    end
  end

  describe '#deactivate' do
    context '教育コーチはアクティブ' do
      it '教育コーチは非活性化される' do
        expect {
          subject.deactivate
        }.to change{subject.active?}.from(true).to(false)
      end
    end

    context '指導中の受講者がいる場合' do
      before(:each) do
        subject.assign_student(student)
      end

      it 'アクティブなまま' do
        expect {
          subject.deactivate.should be_false
        }.not_to change{subject.reload.active?}
      end
    end
  end
end
