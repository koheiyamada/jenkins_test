class Bs::BssController < ApplicationController
  bs_user_only
  block_coach only: [:edit, :update]
  layout 'with_sidebar'

  def show
    @bs = current_user.organization
  end

  def leave
    @bs = current_user.organization
  end

  def edit
    @bs = current_user.organization
  end

  def update
    @bs = current_user.organization
    if @bs.address
      @bs.address.attributes = params[:address]
    else
      @bs.build_address = params[:address]
    end
    if @bs.update_attributes(params[:bs])
      redirect_to action:'show'
    else
      render 'edit'
    end
  end
end
