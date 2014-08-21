# coding:utf-8
require 'spec_helper'

describe BsCustomer do
  let(:postal_code){FactoryGirl.create(:postal_code)}
  let(:bs){FactoryGirl.create(:bs, area_code: postal_code.area_code.code)}

  before(:each) do
    bs
  end

  describe '#resolve_bs!' do
    context '生徒の住所に対応したBSが存在する' do
      it '生徒はそのBSの所属となる' do
        z = postal_code.zip_code
        address = FactoryGirl.build(:address, postal_code1: z.code1, postal_code2: z.code2)
        student = FactoryGirl.create(:student, address:address, organization:Headquarter.instance)
        student.organization.should == Headquarter.instance

        BsCustomer.new(student).resolve_bs!

        Student.find(student.id).organization.should == bs
        student.reload.organization.should == bs
      end

      it 'BSが退会済みだと本部所属になる' do
        z = postal_code.zip_code
        address = FactoryGirl.build(:address, postal_code1: z.code1, postal_code2: z.code2)
        student = FactoryGirl.create(:student, address:address, organization:Headquarter.instance)
        student.organization.should == Headquarter.instance
        bs.leave.should be_true

        BsCustomer.new(student).resolve_bs!

        Student.find(student.id).organization.should == Headquarter.instance
      end
    end

    context '生徒の住所に対応したBSが存在しない' do
      it '生徒は本部の所属となる' do
        address = FactoryGirl.build(:address, postal_code:"000-000000")
        dummy = FactoryGirl.create(:bs)
        student = FactoryGirl.create(:student, address:address, organization:dummy)
        student.organization.should_not == Headquarter.instance

        BsCustomer.new(student).resolve_bs!

        student.reload.organization.should == Headquarter.instance
      end
    end

    context '受講者の住所に郵便番号がない' do
      it '本部が割り当てられる' do
        z = postal_code.zip_code
        address = FactoryGirl.build(:address, postal_code1: z.code1, postal_code2: z.code2)
        student = FactoryGirl.create(:student, address:address, organization:Headquarter.instance)
        student.organization.should == Headquarter.instance

        BsCustomer.new(student).resolve_bs!

        student.reload.organization.should == bs

        student.address.update_attributes(postal_code1: '', postal_code2: '')
        Student.find(student.id).organization.should == Headquarter.instance
      end
    end
  end
end