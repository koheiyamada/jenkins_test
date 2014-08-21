class Hq::YuchoAccountApplicationsController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def index
    # kaminariが勝手に継承元のdefault_scopeを使ってしまうので継承元からスタート
    @yucho_account_applications = MembershipApplication.unscoped.where(type:"YuchoAccountApplication").
                                  only_new.order('created_at DESC').page(params[:page])
  end
  
  def show
    @yucho_account_application = YuchoAccountApplication.find(params[:id])
    @temp_yucho_account = @yucho_account_application.temp_yucho_account
  end

  # POST membership_application/:id/accept
  def accept
    @yucho_account_application = YuchoAccountApplication.find(params[:id])
    @yucho_account_application.accept
    if @yucho_account_application.errors.empty?
      redirect_to({action: :show, id: @yucho_account_application}, notice: t('yucho_account_application.accepted'))
    else
      render :show
    end
  end

  # POST membership_application/:id/reject
  def reject
    @yucho_account_application = YuchoAccountApplication.find(params[:id])
    @yucho_account_application.reject
    if @yucho_account_application.errors.empty?
      redirect_to path_on_rejected, notice: t('yucho_account_application.rejected')
    else
      render :show
    end
  end

  private

    def path_on_created
      root_path
    end

    def path_on_rejected
      {action: :index}
    end
end
