class Hq::BsAppFormsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control
  layout 'with_sidebar'

  def index
    if params[:q]
      page = params[:page] || 1
      @bs_app_forms = BsAppFormSearch.new(current_user).search_unprocessed_forms(params[:q], page: page)
    else
      @bs_app_forms = BsAppForm.confirmed.unprocessed.order('created_at DESC').page(params[:page])
    end
  end

  def processed
    if params[:q]
      page = params[:page] || 1
      @bs_app_forms = BsAppFormSearch.new(current_user).search_processed_forms(params[:q], page: page)
    else
      @bs_app_forms = BsAppForm.processed.order('created_at DESC').page(params[:page])
    end
  end

  def show
    @bs_app_form = BsAppForm.find(params[:id])
  end

  # POST /hq/ad/bs_app_forms/1/create_tutor
  def create_user
    @bs_app_form = BsAppForm.find(params[:id])
    @bs_user = @bs_app_form.create_bs_and_bs_user!
    session[:new_bs_user] = {user_name:@bs_user.user_name, password:@bs_user.password}
    redirect_to action:"registered"
  end

  # POST /hq/ad/bs_app_forms/1/reject
  def reject
    @bs_app_form = BsAppForm.find(params[:id])
    if @bs_app_form.reject
      redirect_to({action: 'index'}, notice: t("messages.rejected_bs_application"))
    else
      render :show
    end
  end

  def registered
    @bs_app_form = BsAppForm.find(params[:id])
  end

  def destroy
    @bs_app_form = BsAppForm.find_by_id(params[:id])
    if @bs_app_form
      @bs_app_form.destroy
      logger.info "BS App Form of ID #{@bs_app_form.id} is deleted."
    end
    redirect_to action: :processed
  end

end
