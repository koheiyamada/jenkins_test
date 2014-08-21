class Hq::UsersController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def show
    @user = User.find(params[:id])
  end

  def change_password
    @user = User.find(params[:id])
    if request.put?
      if @user.update_password(params[@user.class.name.underscore.to_sym])
        redirect_to({action:"show"}, notice:t("messages.password_updated"))
      end
    end
  end
end
