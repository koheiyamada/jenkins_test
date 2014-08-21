# coding:utf-8
class UsersController < ApplicationController

  def change_password
    @user = User.find(params[:id])
    if request.put?
      # 他者のパスワードなので再ログインはしない
      if @user.update_password(params[@user.class.name.underscore.to_sym])
        redirect_to({action:"show"}, notice:t("messages.password_updated"))
      end
    end
  end

  private

    def subject
      current_user
    end
end
