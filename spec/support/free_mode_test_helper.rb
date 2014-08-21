# encoding:utf-8

# テストに役立つメソッド集
module FreeModeTestHelper

  # ログインサンプルハッシュ集。autologinメソッドに使用可能
  # 例：　autologin(@login_samples[:sample_hq])
  def initialize
    super
    @login_samples = {
      sample_st_ad_free:    {name: 'u14960z', pass: '1234'},
      sample_pa_free:       {name: 'p14vh5u', pass: '1234'},
      sample_st_ch_free:    {name: 'u143tef', pass: '1234'},

      sample_st_ad_premium: {name: 'u145eib', pass: '1234'},
      sample_pa_premium:    {name: 'p14wl99', pass: '1234'},
      sample_st_ch_premium: {name: 'u145fn7', pass: '1234'},
      sample_st_took_lessons: {name: 'u133da9', pass: 'tera'},

      sample_hq:            {name: 'tera',    pass: 'tera'},
      sample_tutor:         {name: 't146nsg', pass: '1111'},
      sample_bs:            {name: 'b14vszz', pass: '1111'},
      sample_coach:         {name: 'c14pf9w', pass: '1111'},
      sample_pa:            {name: 'p13lnam', pass: 'tera'}
    }
  end

  # メール認証を済ませて登録情報入力画面に遷移するところまでを実行
  # 引数は 'student' か 'parent'
  def issue_token(type)
    visit '/confirmation1'
    if type == 'student' then
      click_button '２０歳以上'
    elsif type == 'parent' then
      click_button '２０歳未満'
    end

    if SystemSettings.free_mode? && type == 'parent'
      check '了承しました'
      click_button '次へ'
    elsif !SystemSettings.free_mode?
      click_button 'はい'
    end
    expect(current_path).to eq '/mail-certification'
    fill_in 'email_confirmation_form_email_local', with: 'yamada.kouhei'
    fill_in 'email_confirmation_form_email_domain', with: 'vareal.co.jp'
    check('email_confirmation_form_agree_pledge')
    click_button '送信'
    expect(current_path).to eq '/mail_certification_complete'
    if type == 'student' then
      form = StudentRegistrationForm.last
    elsif type == 'parent' then
      form = ParentRegistrationForm.last
    end
    expect(form).not_to be_blank
    visit "/registration/#{type}s/confirm?token=#{form.confirmation_token}"
    expect(page).to have_selector("#new_#{type}")
  end

  # 未成年受講者のメール認証を済ませて登録情報入力画面に遷移するところまで
  # !!保護者でログインしている状態で実行しないといけない点に注意!!
  def issue_child_token()
    visit '/pa/students'
    click_link_or_button '新しく作成する'
    expect(current_path).to eq '/pa/students/mail_certification'

    fill_in 'email_confirmation_form_email_local', with: 'yamada.kouhei'
    fill_in 'email_confirmation_form_email_domain', with: 'vareal.co.jp'

    click_link_or_button '送信'
    expect(current_path).to eq '/pa/students'
    form = StudentRegistrationForm.last
    expect(form).not_to be_blank
    visit "/registration/students/register_minor_student?token=#{form.confirmation_token}"
  end

  # ログイン用メソッド
  # {name: 'str', pass: 'str'}の形式のハッシュを引数にとる
  # create_usrの返り値がそのまま使えます
  def autologin(sample)
    visit '/sign_in'
    if current_path != '/sign_in'
      click_link 'サインアウト'
    end
    fill_in 'user_user_name', with: sample[:name]
    fill_in 'user_password', with: sample[:pass]
    click_button 'ログイン'
  end

  # 無料体験モードON/OFF制御
  # 引数はString 'ON'　か　'OFF'
  # 実行後はサインアウト状態になる
  def set_free_mode(mode)
    autologin(@login_samples[:sample_hq])

    click_link '無料体験設定'
   
    visit '/hq/free_mode_settings/edit'
    if mode == 'ON'
      select '開始', from: 'system_settings_free_mode'
    elsif mode == 'OFF'
      select '停止', from: 'system_settings_free_mode'
    end

    click_button '更新'
    click_link 'サインアウト'
  end

  def set_lesson_expiration_date(day)
    autologin(@login_samples[:sample_hq])

    click_link '無料体験設定'
   
    visit '/hq/free_mode_settings/edit'
    fill_in 'system_settings_free_lesson_expiration_date', with: day

    click_button '更新'
    click_link 'サインアウト'
  end

  def set_cs_mode(mode)
    autologin(@login_samples[:sample_hq])

    click_link 'システム設定'
   
    visit '/hq/system_settings/edit'
    if mode == 'ON'
      select '有効', from: 'system_settings_cs_point_visible'
    elsif mode == 'OFF'
      select '無効', from: 'system_settings_cs_point_visible'
    end

    click_button '更新'
    click_link 'サインアウト'
  end

  # IDに使用可能なランダム文字列を生成
  def random_string
    char_set = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map{|i| i.to_a}.flatten | ['_', '-', '@', '.']
    (0...7).map{char_set[rand(char_set.length)]}.join
  end

  # 成年受講者用登録フォーム自動入力メソッド
  def autoform_student_adult
    fill_in 'student_user_name', with: 'test_id-' + random_string
    fill_in '姓', with: '受講'
    fill_in '名', with: '成年'
    fill_in 'せい', with: 'じゅこう'
    fill_in 'めい', with: 'せいねん'
    fill_in 'student_nickname', with: 'testnickname=' + random_string
    fill_in 'student_phone_number', with: '111-1111-1111'
    fill_in 'address_postal_code1', with: '111'
    fill_in 'address_postal_code2', with: '1111'
    fill_in 'address_state', with: '福岡県'
    fill_in 'address_line1', with: '福岡県福岡市'
    choose 'student_sex_male'
    unless SystemSettings.free_mode?
      choose 'クレジットカード'
    end
    select '社会人', from: 'student_info_grade_id'
    select 'Mac OS X v10.6 Snow Leopard', from: 'user_operating_system_operating_system_id'
    choose 'how_to_find_answer_option_web_site'
    check '自分の好きなときにできるから'
    click_button '確認'
    click_link '次へ'
    @student = User.last
    #ここでtemplete error、ただし登録は完了している
  end

  # 未成年受講者用登録フォーム自動入力メソッド
  def autoform_student_child
    fill_in 'student_user_name', with: 'test_id-' + random_string
    fill_in '姓', with: '受講'
    fill_in '名', with: '未成年'
    fill_in 'せい', with: 'じゅこう'
    fill_in 'めい', with: 'みせいねん'
    fill_in 'student_email', with: 'yamada.kouhei@vareal.co.jp'
    fill_in 'student_nickname', with: 'testnickname=' + random_string
    fill_in 'student_phone_number', with: '111-1111-1111'
    fill_in 'address_postal_code1', with: '111'
    fill_in 'address_postal_code2', with: '1111'
    fill_in 'address_state', with: '福岡県'
    fill_in 'address_line1', with: '福岡県福岡市'
    choose 'student_sex_male'
    click_button '登録する'
    @child = User.last
  end

  # 保護者用登録フォーム自動入力メソッド
  def autoform_parent
    fill_in 'parent_user_name', with: 'test_id-' + random_string
    fill_in '姓', with: '保護'
    fill_in '名', with: '者'
    fill_in 'せい', with: 'ほご'
    fill_in 'めい', with: 'しゃ'
    fill_in 'parent_phone_number', with: '111-1111-1111'
    fill_in 'address_postal_code1', with: '111'
    fill_in 'address_postal_code2', with: '1111'
    fill_in 'address_state', with: '福岡県'
    fill_in 'address_line1', with: '福岡県福岡市'
    choose 'parent_sex_male'
    unless SystemSettings.free_mode?
      choose 'クレジットカード'
    end
    select 'Mac OS X v10.6 Snow Leopard', from: 'user_operating_system_operating_system_id'
    choose 'how_to_find_answer_option_web_site'
    check '自分の好きなときにできるから'
    click_button '確認'
    click_link '次へ'
    @parent = User.last
  end

  # ユーザーを登録してハッシュにユーザーIDとパスワードを格納して返す
  # 引数はString 'student'　か　'parent'
  # 返り値：　{name: 'str', pass: 'str'}
  # 無料体験モードOFF時は支払方法としてクレジットカードが登録されている
  # 実行後はサインアウト状態なので注意
  def create_usr(type)
    #type: 'student' or 'parent'

    issue_token(type)

    if type == 'student' then
      autoform_student_adult
    elsif type == 'parent' then
      autoform_parent
    end

    unless SystemSettings.free_mode?
      click_link 'クレジットカード登録'
      fill_in 'credit_card_number', with: '4111111111111111'
      fill_in 'credit_card_security_code', with: '111'
      select '20', from: 'credit_card_expire_1i'
      click_button '送信する'
    end

    autologin({name: 'tera',    pass: 'tera'})

    if type == 'student' then
      visit "/hq/students/#{@student.id}/change_password"
      fill_in 'student_password', with: '1234'
      fill_in 'student_password_confirmation', with: '1234'
      click_button '変更'
      retsample = {name: @student.user_name, pass: '1234'}
    elsif type == 'parent' then
      visit "/hq/parents/#{@parent.id}/change_password"
      fill_in 'parent_password', with: '1234'
      fill_in 'parent_password_confirmation', with: '1234'
      click_button '変更'
      retsample = {name: @parent.user_name, pass: '1234'}
    else
      retsample = {name: '',pass: ''}
    end
    return retsample
  end


  # 引数のparent_sample（形式は必ず{name: 'str', pass:'str'}）の子受講者を作成
  # 返り値はcreate_usrと同じ
  def create_minor_student(parent_sample)
    autologin(parent_sample)
    issue_child_token
    student = autoform_student_child


    autologin({name: 'tera', pass: 'tera'})
    visit "/hq/students/#{student.id}/change_password"
    fill_in 'student_password', with: '1234'
    fill_in 'student_password_confirmation', with: '1234'
    click_button '変更'
    student_sample = {name: student.user_name, pass: '1234'}

    return student_sample
  end



  RSpec.configure do |config|
    config.include FreeModeTestHelper, :type => :request
  end
end