# coding: utf-8

require 'spec_helper'

describe ParentService do

  describe '#create_student' do
    before(:each) do
      @postal_code = FactoryGirl.create(:postal_code)
      zip_code = @postal_code.zip_code
      @address = FactoryGirl.create(:address, postal_code1: zip_code.code1, postal_code2: zip_code.code2)
      @parent = FactoryGirl.create(:active_parent, address: @address)
    end

    context '住所に対応するBSが居る' do
      before(:each) do
        @bs = FactoryGirl.create(:bs, area_code: @postal_code.area_code.code)
        @bs_user = FactoryGirl.create(:bs_user, organization: @bs)
        @bs.set_representative(@bs_user)
      end

      it '受講者の担当BSになる' do
        student_attrs = FactoryGirl.attributes_for(:student)
        address_attrs = FactoryGirl.attributes_for(:address, postal_code1: @address.postal_code1, postal_code2: @address.postal_code2)
        params = {
          student: student_attrs,
          address: address_attrs,
          student_info: {
            grade_id: Grade.first.id
          }
        }
        service = ParentService.new(@parent)
        student = service.create_student(params)
        student.should be_persisted
        student.organization.should == @bs
      end
    end

    it '受講者のenrolled_atがセットされる' do
      student_attrs = FactoryGirl.attributes_for(:student)
      address_attrs = FactoryGirl.attributes_for(:address, postal_code1: @address.postal_code1, postal_code2: @address.postal_code2)
      params = {
        student: student_attrs,
        address: address_attrs,
        student_info: {
          grade_id: Grade.first.id
        }
      }
      service = ParentService.new(@parent)
      student = service.create_student(params)
      student.should be_persisted
      student.enrolled_at.should_not be_nil
    end
  end
end
