# encoding:utf-8
require 'spec_helper'

describe CsSheet do
  disconnect_sunspot

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student)}
  let(:student2) {FactoryGirl.create(:student, user_name:"student2")}
  let(:subject) {FactoryGirl.create(:subject)}

  before(:each) do
    t = 1.day.from_now
    @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], subject:subject, start_time:t)
    @lesson.student_attended(student)
  end

  it 'チューターのCSポイントが加算される' do
    expect {
      FactoryGirl.create(:cs_sheet, author: student, lesson: @lesson, content: 'Good!', score: 4)
    }.to change{Tutor.find(tutor.id).info.cs_points}.by(1)
  end

  it 'チューターの最近のCSポイントが加算される' do
    expect {
      FactoryGirl.create(:cs_sheet, author: student, lesson: @lesson, content: 'Good!', score: 4)
    }.to change{Tutor.find(tutor.id).cs_points_of_recent_lessons}.by(1)
  end

  it 'チューターの平均CSポイントが変化する' do
    expect {
      FactoryGirl.create(:cs_sheet, author: student, lesson: @lesson, content: 'Good!', score: 4)
    }.to change{Tutor.find(tutor.id).average_cs_points}.by(1)
  end

  it '同じレッスンについて同じ人が複数作ることはできない' do
    CsSheet.create!(lesson: @lesson, score: 5, content: 'great', author: student)
    cs_sheet = CsSheet.new(lesson: @lesson, score: 3, content: 'so so', author: student)
    cs_sheet.should_not be_valid
    cs_sheet.errors.full_messages.should == ['このレッスンのCSシートは提出済みです。']
  end

  describe "CSシートを作成する" do
    context "授業を受けたのは1人" do
      it "授業のCSポイントが計算される" do
        expect {
          CsSheet.create!(lesson:@lesson, score:5, content:"great", author:student)
        }.to change{@lesson.cs_point}.from(nil).to(2)
      end

      it "授業の状態がレポートありになる" do
        expect {
          CsSheet.create!(lesson:@lesson, score:5, content:"great", author:student)
        }.to change{@lesson.cs_sheets_collected?}.from(false).to(true)
      end

      it "評価が５のCSシートが24の倍数になると時間単位基本報酬改定ポイントが１増える" do
        @lesson.tutor.info.update_attribute(:good_cs_score_count, 23)
        expect {
          CsSheet.create!(lesson:@lesson, score:5, content:"great", author:student)
        }.to change{@lesson.tutor.info.upgrade_points}.by(1)
      end

      context "低評価の場合" do
        it "理由が必要" do
          CsSheet.new(lesson:@lesson, score:2, content:"great", author:student).should be_invalid
        end

        it "スコアが２のときはCSポイントは-1" do
          cs_sheet = CsSheet.create!(lesson:@lesson, score:2, content:"great", author:student, reason_for_low_score:"bad_explanation")
          cs_sheet.cs_point.should == -1
        end

        it "スコアが1のときはCSポイントは-3" do
          cs_sheet = CsSheet.create!(lesson:@lesson, score:1, content:"great", author:student, reason_for_low_score:"bad_explanation")
          cs_sheet.cs_point.should == -3
        end

        it "低評価でも、理由がPCトラブルならCSポイントはゼロとなる" do
          cs_sheet = CsSheet.create!(lesson:@lesson, score:2, content:"great", author:student, reason_for_low_score:"pc_trouble")
          cs_sheet.cs_point.should == 0
        end
      end
    end

    context "授業を受けたのは2人" do
      before(:each) do
        @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student, student2], subject:subject, start_time:1.hour.from_now, units:1)
        @lesson.student_attended(student)
        @lesson.student_attended(student2)
      end

      it "一人がCSシートを書いてもレッスンのCSポイントはまだ計算されない" do
        expect {
          CsSheet.create!(lesson:@lesson, author:student, score:5, content:"hello")
        }.not_to change{@lesson.cs_point}
      end

      it "一人がCSシートを書いてもレッスンの状態は変化しない" do
        expect {
          CsSheet.create!(lesson:@lesson, author:student, score:5, content:"hello")
        }.not_to change{@lesson.status}
      end

      it "二人とも書けばCSポイントが計算される" do
        expect {
          CsSheet.create!(lesson:@lesson, author:student, score:5, content:"hello")
          CsSheet.create!(lesson:@lesson, author:student2, score:4, content:"hello2")
        }.to change{@lesson.cs_point}.from(nil).to(1.5)
      end

      it "二人とも書けば状態がreportedになる" do
        expect {
          CsSheet.create!(lesson:@lesson, author:student, score:5, content:"hello")
          CsSheet.create!(lesson:@lesson, author:student2, score:4, content:"hello2")
        }.to change{@lesson.cs_sheets_collected?}.from(false).to(true)
      end
    end
  end
end
