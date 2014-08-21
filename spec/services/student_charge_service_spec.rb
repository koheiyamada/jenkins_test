# coding:utf-8
require 'spec_helper'

describe StudentChargeService do

  let(:student){FactoryGirl.create(:student)}
  subject{StudentChargeService.new(student)}

  describe '.id_management_fee_threshold' do
    it '2013年5月の場合は2013年4月20日23時59分59秒を返す' do
      t = StudentChargeService.id_management_fee_threshold(2013, 5)
      t.year.should == 2013
      t.month.should == 4
      t.day.should == 20
      t.hour.should == 23
      t.min.should == 59
      t.sec.should == 59
    end

    it '2014年1月の場合は2013年12月20日23時59分59秒を返す' do
      t = StudentChargeService.id_management_fee_threshold(2014, 1)
      t.year.should == 2013
      t.month.should == 12
      t.day.should == 20
      t.hour.should == 23
      t.min.should == 59
      t.sec.should == 59
    end
  end

  describe '.students_of_id_management_fee(year, month)' do
    before(:each) do
      @student1 = FactoryGirl.create(:active_student)
      @student2 = FactoryGirl.create(:active_student)
      @student1.update_column :created_at, Time.current.change(day: SystemSettings.cutoff_date)
      @student2.update_column :created_at, Time.current.change(day: SystemSettings.cutoff_date + 1)
    end

    it '１ヶ月以上まえに登録された受講者だけを返す' do
      t = 1.month.from_now
      students = StudentChargeService.students_of_id_management_fee(t.year, t.month)
      students.should have(1).item
      students.first.should == @student1
    end
  end

  describe '#more_than_one_month_since_enrolled?' do
    let(:today){Date.today}

    context '先々月に入会' do
      it '締め日前なら true' do
        student.stub(:enrolled_at){2.months.ago.change(day: SystemSettings.cutoff_date)}
        subject.should be_more_than_one_month_since_enrolled(today.year, today.month)
      end

      it '締め日後も true' do
        student.stub(:enrolled_at){2.months.ago.change(day: SystemSettings.cutoff_date + 1)}
        subject.should be_more_than_one_month_since_enrolled(today.year, today.month)
      end
    end

    context '先月入会' do
      it '締め日前なら true を返す' do
        student.stub(:enrolled_at){1.month.ago.change(day: SystemSettings.cutoff_date)}
        subject.should be_more_than_one_month_since_enrolled(today.year, today.month)
      end

      it '締め日後なら false を返す' do
        student.stub(:enrolled_at){1.month.ago.change(day: SystemSettings.cutoff_date + 1)}
        subject.should_not be_more_than_one_month_since_enrolled(today.year, today.month)
      end
    end

    context '今月入会' do
      it '締め日前でも false' do
        student.stub(:enrolled_at){Time.current.change(day: SystemSettings.cutoff_date)}
        subject.should_not be_more_than_one_month_since_enrolled(today.year, today.month)
      end

      it '締め日後でも false' do
        student.stub(:enrolled_at){Time.current.change(day: SystemSettings.cutoff_date + 1)}
        subject.should_not be_more_than_one_month_since_enrolled(today.year, today.month)
      end
    end
  end

  describe '#charge_for_month' do
    let(:today){Date.today}

    context '受講者は本部の紹介を受けている' do
      before(:each) do
        student.stub(:referenced_by_hq_user?){true}
      end

      it '紹介割引が発生する' do
        expect {
          subject.charge_for_month(today.year, today.month)
        }.to change(Account::HqUserReferenceDiscount, :count).by(1)
      end

      it '割引額はレッスン料金の合計の5%' do
        sum_of_lesson_fee = 10000
        subject.stub(:calculate_lesson_fees_of_month){sum_of_lesson_fee}

        subject.charge_for_month(today.year, today.month)
        entry = Account::HqUserReferenceDiscount.last
        entry.amount_of_money_received.should == 0
        entry.amount_of_payment < 0
        entry.amount_of_payment == - 0.05 * sum_of_lesson_fee
      end
    end

    context '受講者は本部の紹介を受けている' do
      before(:each) do
        student.stub(:referenced_by_hq_user?){false}
      end

      it '紹介割引は発生しない' do
        expect {
          subject.charge_for_month(today.year, today.month)
        }.not_to change(Account::HqUserReferenceDiscount, :count)
      end
    end
  end
end