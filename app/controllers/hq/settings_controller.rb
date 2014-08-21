class Hq::SettingsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :system_settings
  layout 'with_sidebar'

  def index
    
  end

  def show
    @system_settings = SystemSettings.first
  end

  def edit
    @system_settings = SystemSettings.first
  end

  def update
    @system_settings = SystemSettings.first
    if @system_settings.update_attributes(params[:system_settings])
      redirect_to action:"show"
    else
      render action:"edit"
    end
  end
end
