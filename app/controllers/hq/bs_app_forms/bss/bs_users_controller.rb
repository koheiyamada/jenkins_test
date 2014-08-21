class Hq::BsAppForms::Bss::BsUsersController < ApplicationController
  hq_user_only
  layout 'with_sidebar'
  before_filter :prepare_bs_app_form_and_bs

  def new
    if @bs.representative.present?
      redirect_to action:'show'
    else
      @bs_user = @bs.new_representative
    end
  end

  def show
    @bs_user = @bs.representative
  end

  def create
    @bs_user = BsUser.new(params[:bs_user]) do |bs_user|
      bs_user.organization = @bs
      bs_user.address = Address.new(params[:address]) if params[:address].present?
      bs_user.user_operating_system = UserOperatingSystem.new(params[:user_operating_system])
    end
    if @bs_user.save
      @bs.set_representative(@bs_user)
      logger.debug "@bs.representative.id = #{Bs.find(@bs.id).representative_id}"
      redirect_to action:'show'
    else
      render action:'new'
    end
  end

  private

    def prepare_bs_app_form_and_bs
      @bs_app_form = BsAppForm.find(params[:bs_app_form_id])
      @bs = @bs_app_form.bs
    end
end
