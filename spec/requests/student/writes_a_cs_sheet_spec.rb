# encoding:utf-8
require 'spec_helper'

describe 'CSシートを書く' do
  let(:student) {FactoryGirl.create(:active_student)}
  before(:each) do
    login_as(student)
    @tutor = FactoryGirl.create(:tutor, anytime_available:true)
    @subject = FactoryGirl.create(:subject)
    @lesson = FactoryGirl.create(:optional_lesson, tutor:@tutor, subject:@subject, students:[student], start_time:1.hour.from_now, units:1)
    @lesson.student_attended(student)
    @lesson.tutor_attended
    @lesson.should be_started
  end

  context '授業が終わっている場合' do
    it 'レッスンページからCSシートページを開いて書く' do
      @lesson.done!

      visit "/st/lessons/#{@lesson.id}"
      page.should have_selector('.lesson')
      #page.should have_selector(".actions > a")

      click_link 'レポートを書く'

      current_path.should == "/st/lessons/#{@lesson.id}/cs_sheet/new"

      choose 'cs_sheet_score_5'
      click_button '提出'

      # レッスンページに戻る
      current_path.should == "/st/lessons/#{@lesson.id}"

      # 作成したCSシートを見る
      click_link I18n.t('common.self')
      cs_sheet = CsSheet.last
      current_path.should == "/st/cs_sheets/#{cs_sheet.id}"
    end
  end

  context 'レッスンは完了状態ではないが、終了予定時刻を過ぎている場合' do
    before(:each) do
      Time.stub(:now){1.second.since @lesson.end_time}
    end

    it 'レッスンページからCSシート作成ページを開くことができる' do
      visit "/st/lessons/#{@lesson.id}"
      page.should have_selector('.lesson')

      click_link 'レポートを書く'

      current_path.should == "/st/lessons/#{@lesson.id}/cs_sheet/new"
    end
  end

  context '授業が終わっていない場合' do
    it 'レポート作成ページを開くことができない'
  end

  context 'すでにCSシートが書かれている場合' do
    before(:each) do
      @lesson.done!
      visit "/st/lessons/#{@lesson.id}/cs_sheet/new"
      choose 'cs_sheet_score_5'
      #fill_in "レポート", with: "Awesome lesson!"
      #select "3", with: "評価"
      click_button '提出'
    end

    it '「レポートを見る」リンクが表示される' do
      visit "/st/lessons/#{@lesson.id}"

      within(:css, ".cs_sheet") do
        page.should have_content(I18n.t('common.self'))
      end
    end

    it '新規作成ページを見ることができない。'
  end

end
