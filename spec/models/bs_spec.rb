# encoding:utf-8
require 'spec_helper'

describe Bs do

  let(:bs) {FactoryGirl.create(:bs)}

  describe "作成する" do
    let(:address) {FactoryGirl.build(:address)}

    it "名前、Eメール、電話番号、住所があればOK" do
      Bs.new(name:"hoge", email:"shimokawa@soba-project.com", phone_number:"111-1111-1111", address:address).should be_valid
    end

    it "名前はオプション" do
      FactoryGirl.build(:bs, name:nil).should be_valid
    end

    it "Eメール必須" do
      FactoryGirl.build(:bs, email:nil).should be_invalid
    end

    it "電話番号必須" do
      FactoryGirl.build(:bs, phone_number:nil).should be_invalid
    end

    it "住所必須" do
      FactoryGirl.build(:bs, address:nil).should be_invalid
    end

    context "住所にエリアコードが割り当てられている場合" do
      before(:each) do
        @address = FactoryGirl.create(:address)
        zip_code = FactoryGirl.create(:zip_code, code: @address.postal_code)
        @postal_code = FactoryGirl.create(:postal_code, zip_code: zip_code)
      end

      it "作成時にエリアコードが割り当てられる" do
        bs = FactoryGirl.create(:bs, address:@address, area_code:nil)
        bs.area_code.should == @postal_code.area_code.code
      end
    end

    describe "BsUserアカウントをあわせて作成する" do
      it "アカウントに関連付けられる" do
        attrs = FactoryGirl.attributes_for(:bs)
        bs_user_attrs = FactoryGirl.attributes_for(:bs_user)
        address_attrs = FactoryGirl.attributes_for(:address)

        bs = Bs.new(attrs) do |obj|
          obj.address = Address.new(address_attrs)
        end
        bs.save.should be_true

        bs_user = BsUser.new(bs_user_attrs) do |user|
          user.organization = bs
        end
        bs_user.save.should be_true

        bs.representative = bs_user

        bs_user = BsUser.last
        bs_user.organization.should == bs
        Bs.find(bs.id).representative == bs_user
      end
    end
  end

  describe "#create_member" do
    it "必要な属性を与えるとBSアカウントを作成する" do
      bs = FactoryGirl.create(:bs)
      attrs = FactoryGirl.attributes_for(:bs_user)

      user = bs.create_member(attrs)
      user.should be_a(BsUser)
      user.user_name.should == attrs[:user_name]
      user.organization.should == bs
      user.pc_spec.should == attrs[:pc_spec]
      user.line_speed.should == attrs[:line_speed]
    end
  end

  describe ".search_by_postal_code" do
    before(:each) do
      @postal_code = FactoryGirl.create(:postal_code)
      @bs = FactoryGirl.create(:bs, area_code: @postal_code.area_code.code)
    end

    it "郵便番号から担当BSを探す" do
      bs = Bs.search_by_postal_code(@postal_code.postal_code)
      bs.area_code.should == @postal_code.area_code.code
    end

    it "存在しない郵便番号の場合はnilを返す" do
      Bs.search_by_postal_code("3456789").should be_nil
    end

    it "存在しない郵便番号の場合、第二引数が与えられていればそれを返す" do
      Bs.search_by_postal_code("3456789"){ Headquarter.first }.should == Headquarter.first
    end
  end

  describe '#leave 退会する' do
    let(:bs) {FactoryGirl.create(:bs)}

    it '非アクティブ化される' do
      expect{
        bs.leave.should be_true
      }.to change{bs.active?}.from(true).to(false)
    end

    it '所属する生徒は本部所属に切り替わる' do
      student = FactoryGirl.create(:student, organization:bs)
      student.organization.should == bs
      bs.leave.should be_true
      student.reload.organization.should == Headquarter.instance
    end

    it '生徒の教育コーチは空になる' do
      bs_user = FactoryGirl.create(:bs_user, organization:bs)
      bs.set_representative bs_user
      student = FactoryGirl.create(:student, organization:bs)
      student.coach.should == bs_user
      student.organization.should == bs

      bs.leave.should be_true
      student.reload.coach.should be_blank
    end

    it '退会時刻が記録される' do
      bs.left_at.should be_nil
      bs.leave.should be_true
      bs.left_at.should_not be_nil
    end
  end

  describe '削除する' do
    let(:bs) {FactoryGirl.create(:bs)}

    it "所属する生徒は本部所属に切り替わる" do
      student = FactoryGirl.create(:student, organization:bs)
      student.organization.should == bs
      expect {
        Bs.find(bs.id).destroy
      }.to change{student.reload.organization_id}.from(bs.id).to(Headquarter.instance.id)
    end

    it '教育コーチアカウントは削除される' do
      bs_user = FactoryGirl.create(:bs_user, organization: bs)
      expect {
        Bs.find(bs.id).destroy
      }.to change(BsUser, :count).by(-1)
    end
  end

  describe "#update_monthly_result! 月のレッスン売上を計算する" do
    let(:student) {FactoryGirl.create(:student, organization:bs)}
    let(:tutor) {FactoryGirl.create(:tutor)}

    context "来月オプションレッスンがある" do
      before(:each) do
        @t = 1.month.from_now.change(day:20)
      end

      context 'チューターが仮登録の場合' do
        before(:each) do
          Tutor.any_instance.stub(:regular?).and_return(false)
          @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:@t, units:1)
          @lesson.establish
        end

        it '売上に反映される' do
          expect{
            @lesson.journalize!
            bs.update_monthly_result!(@t.year, @t.month)
          }.to change{Bs.find(bs.id).lesson_sales_of_month(@t.year, @t.month)}.by(@lesson.fee(student))
        end
      end

      context 'チューターが本登録の場合' do
        before(:each) do
          @t = 1.month.from_now.change(day:20)
          Tutor.any_instance.stub(:regular?).and_return(true)
          @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:@t, units:1)
          @lesson.establish
        end

        it "来月の売上に加算される" do
          expect{
            @lesson.journalize!
            bs.update_monthly_result!(@t.year, @t.month)
          }.to change{Bs.find(bs.id).lesson_sales_of_month(@t.year, @t.month)}.by(@lesson.fee(student))
        end
      end
    end
  end

  describe '#reset_area_code' do
    before(:each) do
      bs.address.should be_present
      zip_code = FactoryGirl.create(:zip_code)
      area_code = FactoryGirl.create(:area_code)
      @area_code = area_code.code
      @postal_code = zip_code.postal_codes.create!(area_code: area_code)
      @address = Address.new(postal_code1: zip_code.code1, postal_code2: zip_code.code2, state: 'Kyoto', line1: 'hoge')
      @bs = FactoryGirl.create(:bs, address: @address, area_code: nil)
      @bs.area_code.should == @postal_code.area_code.code
    end

    it '現在の住所のエリアコードにリセットされる' do
      @bs.update_attribute(:area_code, '444-444')
      expect {
        @bs.reset_area_code.should be_valid
      }.to change{@bs.area_code}.from('444-444').to(@area_code)
    end
  end
end
