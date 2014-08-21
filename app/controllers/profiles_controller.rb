class ProfilesController < ApplicationController
  def change_password
    @user = subject
    if request.put?
      if @user.update_attributes(params[@user.class.name.underscore.to_sym])
        sign_in @user, :bypass => true
        redirect_to({action:'show'}, notice:t('messages.password_updated'))
      end
    end
  end

  private

    def subject
      current_user
    end
end
