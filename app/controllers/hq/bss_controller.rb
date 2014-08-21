class Hq::BssController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control
  layout 'with_sidebar'

  def index
    if params[:q]
      page = params[:page] || 1
      @bs_list = Bs.search_by_keyword(params[:q], page: page, active: true)
    else
      @bs_list = Bs.only_active.includes(:representative).page(params[:page])
    end
  end

  def left
    if params[:q]
      page = params[:page] || 1
      @bs_list = BsSearch.new(current_user).search(params[:q], page: page, active: false)
    else
      @bs_list = Bs.left.page(params[:page])
    end
  end

  def show
    @bs = Bs.find(params[:id])
  end

  def edit
    @bs = Bs.find(params[:id])
  end

  def update
    @bs = Bs.find(params[:id])
    @bs.attributes = params[:bs]
    if @bs.address.present?
      @bs.address.attributes = params[:address]
    else
      @bs.address.build_address(params[:address])
    end
    if @bs.save
      redirect_to hq_bs_path(@bs), notice:t('messages.updated')
    else
      render action:'edit'
    end
  end

  # GET /hq/ad/bss/:id/resign
  def resign
    @bs = Bs.find(params[:id])
  end

  # GET  /hq/ad/bss/:id/leave
  # POST /hq/ad/bss/:id/leave
  def leave
    @bs = Bs.find(params[:id])
    if request.post?
      if @bs.leave
        redirect_to({action:'index'}, notice: t('messages.bs_left', bs: @bs.name))
      else
        redirect_to({action:'index'}, notice: t('bs.failed_to_deactivate'))
      end
    end
  end

  # POST /hq/bss/:id/activate
  def activate
    @bs = Bs.find(params[:id])
    s = BsAccountService.new(@bs)
    if s.reactivate
      redirect_to action: :show
    else
      redirect_to action: :show
    end
  end

  def destroy
    @bs = Bs.find(params[:id])
    @bs.destroy
    redirect_to({action: 'index'}, notice: t('messages.user_deleted'))
  end
end
