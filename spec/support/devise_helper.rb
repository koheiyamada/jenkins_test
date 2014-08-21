# encoding:utf-8
module AuthenticationRequestHelper
  # for use in request specs
  def sign_in_as(user)
    post_via_redirect user_session_path, 'user[user_name]' => user.user_name, 'user[password]' => user.password
  end

  def login_as(user)
    visit new_user_session_path
    fill_in "ユーザーID", :with => user.user_name
    fill_in "パスワード", :with => user.password
    click_button "ログイン"
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include AuthenticationRequestHelper, :type => :request
end
