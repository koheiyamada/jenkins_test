# coding:utf-8
require 'spec_helper'

describe Student do
  let(:hq_user) {HqUser.first}

  describe 'reference_user_name 本部スタッフに紹介される' do
    it '本部スタッフが紹介者となる' do
      student = FactoryGirl.create(:student, reference_user_name: hq_user.user_name)
      Student.find(student.id).reference.should == hq_user
    end

    it '本部から紹介されたフラグが立つ' do
      student = FactoryGirl.create(:student, reference_user_name: hq_user.user_name)
      Student.find(student.id).should be_referenced_by_hq_user
    end

    describe '本部紹介者が削除される' do
      before(:each) do
        @student = FactoryGirl.create(:student, reference_user_name: hq_user.user_name)
        Student.find(@student.id).should be_referenced_by_hq_user
      end

      it '紹介フラグはそのまま' do
        expect {
          @student.reference_user_name = ''
          @student.save
        }.not_to change{Student.find(@student.id).referenced_by_hq_user}.from(true)
      end
    end
  end
end