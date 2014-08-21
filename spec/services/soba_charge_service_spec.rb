# coding:utf-8

require 'spec_helper'

describe SobaChargeService do
  let(:student) {FactoryGirl.create(:active_student)}
  let(:month){Date.today}

  before(:each) do
    range = DateUtils.period_of_settlement_month(month.year, month.month)
    @start_time = range.first.beginning_of_day
    @end_time   = range.last.end_of_day
  end

  describe '#account_to_charge?' do

    context '受講者' do
      let(:user){student}

      it 'Returns true if the conditions are satisfied' do
        student.stub(:enrolled_at){31.days.ago(@end_time)}
        student.stub(:current_sign_in_at){@end_time}
        student.stub(:active?){true}

        SobaChargeService.new.account_to_charge?(user, month.year, month.month).should be_true
      end

      it '期間末日が入会日から31日目以内であればカウントされない' do
        student.stub(:enrolled_at){30.days.ago(@end_time)}
        student.stub(:current_sign_in_at){@end_time}
        student.stub(:active?){true}

        SobaChargeService.new.account_to_charge?(user, month.year, month.month).should be_false
      end

      it '最終ログイン日時が期間初日以前であればカウントされない' do
        student.stub(:enrolled_at){31.days.ago(@end_time)}
        student.stub(:current_sign_in_at){1.second.ago @start_time}
        student.stub(:active?){true}

        SobaChargeService.new.account_to_charge?(user, month.year, month.month).should be_false
      end

      context '退会済み' do
        before(:each) do
          student.stub(:active?){false}
        end

        it '期間以前に退会していたらカウントされない' do
          student.stub(:enrolled_at){31.days.ago(@end_time)}
          student.stub(:current_sign_in_at){@end_time}
          student.stub(:left_at){1.second.ago @start_time}

          SobaChargeService.new.account_to_charge?(user, month.year, month.month).should be_false
        end

        it '期間初日以降に退会していたらカウントされる' do
          student.stub(:enrolled_at){31.days.ago(@start_time)}
          student.stub(:current_sign_in_at){@end_time}
          student.stub(:left_at){@start_time}

          SobaChargeService.new.account_to_charge?(user, month.year, month.month).should be_true
        end
      end
    end

    context 'チューター' do

    end

    context '本部' do

    end

    context 'BSオーナー' do

    end

    context '教育コーチ' do

    end
  end

  describe '#license_charge_count' do

    context '受講者' do
      let(:user){student}

      it 'Returns true if the conditions are satisfied' do
        student.stub(:enrolled_at){31.days.ago(@end_time)}
        student.stub(:current_sign_in_at){@end_time}
        student.stub(:active?){true}

        SobaChargeService.new.license_charge_count(user, month.year, month.month).should == 1
      end

      it '期間末日が入会日から31日目以内であればカウントされない' do
        student.stub(:enrolled_at){30.days.ago(@end_time)}
        student.stub(:current_sign_in_at){@end_time}
        student.stub(:active?){true}

        SobaChargeService.new.license_charge_count(user, month.year, month.month).should == 0
      end

      it '最終ログイン日時が期間初日以前であればカウントされない' do
        student.stub(:enrolled_at){31.days.ago(@end_time)}
        student.stub(:current_sign_in_at){1.second.ago @start_time}
        student.stub(:active?){true}

        SobaChargeService.new.license_charge_count(user, month.year, month.month).should  == 0
      end

      context '退会済み' do
        before(:each) do
          student.stub(:active?){false}
        end

        it '期間以前に退会していたらカウントされない' do
          student.stub(:enrolled_at){31.days.ago(@end_time)}
          student.stub(:current_sign_in_at){@end_time}
          student.stub(:left_at){1.second.ago @start_time}

          SobaChargeService.new.license_charge_count(user, month.year, month.month).should == 0
        end

        it '期間初日以降に退会していたらカウントされる' do
          student.stub(:enrolled_at){31.days.ago(@start_time)}
          student.stub(:current_sign_in_at){@end_time}
          student.stub(:left_at){@start_time}

          SobaChargeService.new.license_charge_count(user, month.year, month.month).should == 1
        end
      end
    end
  end
end
