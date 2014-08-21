class Hq::ChargeSettingsController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def index
    @charge_settings = ChargeSettings.all
  end

  def edit
    @charge_setting = ChargeSettings.find(params[:id])
  end

  def update
    @charge_setting = ChargeSettings.find(params[:id])
    if @charge_setting.update_attributes(params[:charge_settings])
      redirect_to({action:'index'}, notice:t('messages.updated'))
    else
      render action:'edit'
    end
  end
end
