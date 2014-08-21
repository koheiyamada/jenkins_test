# encoding:utf-8
require "spec_helper"

describe "Registering to use AID" do
  before(:each) do
    visit '/confirmation1'
    click_button '２０歳以上'
    current_path.should == '/confirmation2'
    click_button 'はい'
    current_path.should == '/mail-certification'
  end

  it "メールアドレスが入力されていなければエラー" do
    # フォームに入力
    #fill_in "メールアドレス（PC）", with:"shimokawa@soba-project.com"

    click_button '送信'

    current_path.should == '/process_mail-certification'
  end

  context '確認メール後' do
    before(:each) do
      # フォームに入力
      fill_in 'email_confirmation_form_email_local', with: 'shiomkawa'
      fill_in 'email_confirmation_form_email_domain', with: 'soba-project.com'
      fill_in 'email_confirmation_form_email_local_confirmation', with: 'shiomkawa'
      fill_in 'email_confirmation_form_email_domain_confirmation', with: 'soba-project.com'
      click_button '送信'

      current_path.should == '/mail_certification_complete'
      form = StudentRegistrationForm.last
      form.should_not be_blank

      visit "/registration/students/confirm?token=#{form.confirmation_token}"

      visit "/registration/students/new"
      page.should have_selector("#new_student")
    end

    context 'プロフィールが正しい' do
      before(:each) do
        fill_in 'student[nickname]', with: 'Jonny'
        fill_in '姓', with: '下川'
        fill_in '名', with: '拓治'
        fill_in 'せい', with: 'しもかわ'
        fill_in 'めい', with: 'たくじ'
        fill_in 'student_phone_email', with: 'shimokawa@soba-project.com'
        fill_in '電話番号', with: '111-111-1111'
        fill_in 'address_postal_code1', with: '111'
        fill_in 'address_postal_code2', with: '1111'
        fill_in 'address_state', with: '京都府'
        fill_in 'address_line1', with: '京都市中京区少将井御旅町'
        choose '男性'
        choose 'クレジットカード'
      end

      it "フォームが正しく埋められていればOK" do
        choose 'student_has_web_camera_built_in'
        #choose 'フリーペーパー'
        choose 'how_to_find_answer_option_search_engine_other'
        fill_in 'how_to_find_search_engine_other_value', with: 'test'
        select '小学3年'

        check '自宅でできるから'
        check '自分の好きなときにできるから'

        click_button '確認'

        student = Student.last
        answers = student.answers.to_question(:how_to_find)
        answers.should have(1).item
        answers.first.custom_answer.value.should == 'test'
        student.answers.should have(3).items

        # アカウントが作成されるとクレジットカード登録画面に移動する
        current_path.should == "/registration/students/#{Student.last.id}"
      end

      it 'アンケートに答えてないと再度フォームを表示する' do
        #choose 'フリーペーパー'
        check '自宅でできるから'
        check '自分の好きなときにできるから'

        click_button '確認'

        current_path.should == '/registration/students'
        page.should have_content('エイドネットを知ったきっかけを選んでください')
      end
    end
  end
end
