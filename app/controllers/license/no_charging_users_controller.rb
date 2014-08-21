class License::NoChargingUsersController < ApplicationController
  system_admin_only
  layout 'with_sidebar'

  def index
    @no_charging_users = NoChargingUser.page(params[:page])
  end

  def new
    if params[:q].present?
      page = (params[:page] || 1).to_i
      @users = current_user.search_users(params[:q], page: page)
    else
      @users = []
    end
    @no_charging_user = NoChargingUser.new
  end

  def create
    @no_charging_user = NoChargingUser.new(params[:no_charging_user])
    if @no_charging_user.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def destroy
    @no_charging_user = NoChargingUser.find(params[:id])
    @no_charging_user.destroy
    redirect_to action: :index
  end
end
