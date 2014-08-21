class Hq::HqUsers::AccessAuthoritiesController < ApplicationController
  hq_user_only
  layout 'with_sidebar'
  before_filter :prepare_hq_user
  before_filter :admin_not_allowed

  def show
    redirect_to hq_hq_user_path(@hq_user)
  end

  def edit
    @access_authority = @hq_user.access_authority
  end

  def update
    @access_authority = @hq_user.access_authority
    if @access_authority.update_attributes(params[:access_authority])
      redirect_to action:"show"
    end
  end

  private

    def prepare_hq_user
      @hq_user = HqUser.find(params[:hq_user_id])
    end

    def admin_not_allowed
      if @hq_user.admin?
        redirect_to hq_hq_user_path(@hq_user)
      end
    end
end
