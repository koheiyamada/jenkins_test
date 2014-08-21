# encoding:utf-8
require 'spec_helper'

describe BasicLesson do
  disconnect_sunspot

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student)}
  let(:course) { FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student]) }

  describe "作成する" do
    it "ベーシックレッスン情報をと日付があれば作成できる" do
      BasicLesson.new(course:course, start_time:1.day.from_now).should be_valid
    end

    it "受付済み状態になる" do
      BasicLesson.create!(course:course, start_time:1.day.from_now).should be_accepted
    end

    it "チューター変更時刻は未設定のまま" do
      expect {
        BasicLesson.create!(course:course, start_time:1.day.from_now)
      }.not_to change{course.tutor_changed_at}
    end
  end

  describe "同時レッスン" do
    let(:student2) {FactoryGirl.create(:student, user_name:"student2")}

    describe "料金" do
      it "チューターの賃金が割増になる" do
        lesson = FactoryGirl.create(:basic_lesson, course:course, students:[student, student2])
        lesson.establish
        lesson.journalize!
        tutor_fee = Account::BasicLessonTutorFee.last
        tutor_fee.amount_of_money_received.should == (lesson.tutor_base_wage * 1.2).to_i
      end
    end
  end

  describe "チューターを変更する" do
    before(:each) do
      @lesson = FactoryGirl.create(:basic_lesson, course:course)
      @tutor2 = FactoryGirl.create(:tutor, user_name:"tutor2")
    end

    it "チューターが変わる" do
      @lesson.change_tutor!(@tutor2)
      Lesson.find(@lesson.id).tutor.should == @tutor2
    end

    context "時間帯の変化がない" do
      it "昇給ポイント獲得条件「連続ベーシックレッスン」のカウンタがリセットされる" do
        tutor.info.continuous_basic_lesson_count = 10
        @lesson.change_tutor!(@tutor2)
        tutor.info.continuous_basic_lesson_count.should == 0
      end
    end

    it "チューターの代役を立てた最終日時が記録される" do
      expect {
        @lesson.change_tutor!(@tutor2)
      }.to change{course.tutor_changed_at}
    end
  end

  describe "時間を変更する" do
    before(:each) do
      @lesson = FactoryGirl.create(:basic_lesson, course:course)
    end

    it "開始時間が変わる" do
      new_time = 1.day.since(@lesson.start_time)
      @lesson.change_time!(new_time)
      # 時間どうしを比較するとマイクロ秒レベルの違いで別物とされる
      @lesson.reload.start_time.to_i.should == new_time.to_i
    end

    it "時間幅はかわらない" do
      new_time = 1.day.since(@lesson.start_time)
      expect {
        @lesson.change_time!(new_time)
      }.not_to change{@lesson.reload.duration}
    end

    it "チューターがひと月あたりに日程変更できるカウントを増やす" do
      month = @lesson.start_time
      new_time = 1.day.since(@lesson.start_time)
      course.monthly_stats_for(month.year, month.month).tutor_schedule_change_count.should == 0
      @lesson.change_time!(new_time)
      course.reload.monthly_stats_for(month.year, month.month).tutor_schedule_change_count.should == 1
    end

    it "変更は月１回まで" do
      new_time = 1.day.since(@lesson.start_time)
      @lesson.change_time!(new_time)
      new_time2 = 1.day.since(new_time)
      expect {
        @lesson.change_time!(new_time2)
      }.to raise_error
    end

    it "ベーシックレッスンの時間を変更した最終日時が記録される" do
      new_time = 1.day.since(@lesson.start_time)
      expect {
        @lesson.change_time!(new_time)
      }.to change{course.schedule_changed_at}
    end
  end

  describe "レッスンを終了する" do
    before(:each) do
      @lesson = FactoryGirl.create(:basic_lesson, course:course)
      @lesson.start!
    end

    it "チューターの消化レッスン単位数をインクリメントする" do
      expect {
        @lesson.done!
      }.to change{@lesson.tutor.info.total_lesson_units}.by(1)
    end

    it "消化したレッスンの単位数が88回の倍数になると昇給ポイントが上がる" do
      @lesson.tutor.info.total_lesson_units = 87
      expect {
        @lesson.done!
      }.to change{@lesson.tutor.info.upgrade_points}.by(1)
    end
  end

  describe "キャンセルをする" do
    before(:each) do
      @lesson = FactoryGirl.create(:basic_lesson, course:course)
      @lesson.establish
    end

    context "仕訳未作成の場合" do
      it "返金処理は呼ばれない" do
        @lesson.should_not_receive(:refund!)

        @lesson.cancel
      end
    end

    context "仕訳作成済みの場合" do
      before(:each) do
        @lesson.journalize!
      end

      it "返金処理をする" do
        @lesson.should_receive(:refund!)

        @lesson.cancel
      end

      it "仕訳の数が二倍になる" do
        n = @lesson.journal_entries.count
        n.should_not == 0
        expect {
          @lesson.cancel
        }.to change{@lesson.reload.journal_entries.count}.from(n).to(2 * n)
      end
    end
  end

  describe 'establish' do
    it 'レッスンがキャンセル済みだと何も起きない' do
      lesson = FactoryGirl.create(:basic_lesson, course:course)
      lesson.cancel.should be_true
      lesson.establish.should be_false
      lesson.reload.should_not be_established
    end

    it 'レッスンがnew状態だとestablishedになる' do
      lesson = FactoryGirl.create(:basic_lesson, course:course)
      lesson.establish.should be_true
      lesson.should be_established
    end

    it 'on_establishedが呼ばれる' do
      lesson = FactoryGirl.create(:basic_lesson, course:course)
      lesson.should_receive(:on_established)

      lesson.establish.should be_true
    end
  end

  describe 'journalize!' do
    it 'チューターの賃金は開催月に発生する' do
      lesson = FactoryGirl.create(:basic_lesson, course:course)
      lesson.establish.should be_true
      lesson.journalize!
      lesson.lesson_tutor_fee.year_month.should == DateUtils.aid_month_of_day(lesson.date)
    end

    it '受講者の費用は開催前月に発生する' do
      lesson = FactoryGirl.create(:basic_lesson, course:course)
      lesson.establish.should be_true
      lesson.journalize!
      p lesson.date
      p DateUtils.aid_month_of_day(lesson.date).prev_month
      lesson.lesson_fees.first.year_month.should == DateUtils.aid_month_of_day(lesson.date).prev_month
    end
  end

  describe '#style' do
    it '開始されたレッスンで参加者が1人だと通常レッスンになる' do
      lesson = FactoryGirl.create(:basic_lesson, course:course)

      lesson.stub(:friends_lesson?){true}
      lesson.style.should == :friends

      lesson.stub(:friends_lesson?){false}
      lesson.stub(:shared_lesson?){true}
      lesson.style.should == :shared

      lesson.stub(:started?){true}
      lesson.stub(:group_lesson?){false}

      lesson.style.should == :single
    end
  end
end
