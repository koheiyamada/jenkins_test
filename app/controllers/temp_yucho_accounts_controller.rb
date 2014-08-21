class TempYuchoAccountsController < ApplicationController
  layout 'registration-centered'

  def new
    @temp_yucho_account = TempYuchoAccount.new
  end

  def create
    temp_yucho_param = params[:temp_yucho_account]
    @temp_yucho_account = TempYuchoAccount.new(temp_yucho_param)
    if @temp_yucho_account.save
      if current_user.create_yucho_account_appilcation_with(@temp_yucho_account)
        redirect_to action: :complete and return
      else
        redirect_to root_path and return
      end
    else
      render :new and return
    end
  end

  def complete
  end

  private

    def check_if_user_not_member
      current_user.student? || current_user.parent?
    end
end