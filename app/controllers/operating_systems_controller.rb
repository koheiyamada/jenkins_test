class OperatingSystemsController < ApplicationController
  system_admin_only
  layout 'with_sidebar'

  def index
    @operating_systems = OperatingSystem.order(:display_order)
  end

  def edit
    @operating_system = OperatingSystem.find(params[:id])
  end

  def update
    @operating_system = OperatingSystem.find(params[:id])
    if @operating_system.update_attributes(params[:operating_system])
      redirect_to action: :index
    else
      render :edit
    end
  end
end
