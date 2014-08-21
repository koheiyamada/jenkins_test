class Hq::BsUsersController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def index
    @bs_users = BsUser.order("created_at DESC")
  end

  def show
    @bs_user = BsUser.find(params[:id])
  end
end
