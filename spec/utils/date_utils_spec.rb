# coding:utf-8
require 'spec_helper'

describe DateUtils do
  let(:today){Date.today}
  let(:first_day){today.change(day: 1)}

  describe '.aid_month_of_day' do
    it '締め日前なら当月を返す' do
      DateUtils.aid_month_of_day(today.change(day: SystemSettings.cutoff_date)).should == first_day
    end

    it '締め日後なら翌月を返す' do
      DateUtils.aid_month_of_day(today.change(day: SystemSettings.cutoff_date + 1)).should == first_day.next_month
    end
  end
end
