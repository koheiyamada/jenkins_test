# coding:utf-8

require 'spec_helper'

describe BsMigrationService do
  let(:postal_code) {FactoryGirl.create(:postal_code)}
  let(:bs) {FactoryGirl.create(:bs, address: address, area_code: postal_code.area_code.code)}
  let(:hq) {Headquarter.instance}
  let(:student) {FactoryGirl.create(:student, organization: hq, address: address)}

  def address
    z = postal_code.zip_code
    FactoryGirl.create(:address, postal_code1: z.code1, postal_code2: z.code2)
  end

  before(:each) do
    student.organization.should == hq
    student.address.postal_code.should == bs.address.postal_code
    bs.area_code.should == postal_code.area_code.code
  end

  describe '#immigrate_from_headquarter' do
    it '本部所属でBSのエリアコード内に住んでいる受講者をBSの担当に変更する' do
      m = BsMigrationService.new(bs)
      expect {
        m.immigrate_students_from_headquarter
      }.to change{Student.find(student.id).organization}.from(hq).to(bs)
    end

    it '本部所属でBSのエリアコード外に住んでいる受講者はそのまま' do
      a = FactoryGirl.create(:non_existent_address)
      Student.any_instance.stub(:address){a}

      m = BsMigrationService.new(bs)
      expect {
        m.immigrate_students_from_headquarter
      }.not_to change{Student.find(student.id).organization}.from(hq)
    end
  end
end