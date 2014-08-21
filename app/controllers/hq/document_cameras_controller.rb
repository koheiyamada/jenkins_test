class Hq::DocumentCamerasController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control
  layout 'with_sidebar'

  def index
    redirect_to action:'yearly'
  end

  def yearly
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @monthly_counts = DocumentCamera.of_year(@year).group('month(created_at)').count
  end

  def monthly
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @document_cameras = DocumentCamera.includes(:user).of_month(@shown_month)
    @grouped_document_cameras = @document_cameras.group_by{|camera| camera.date}
  end

  def daily
    @day = (params[:day] || (Time.zone || Time).now.day).to_i
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @date = Date.new(@year, @month, @day)
    @document_cameras = DocumentCamera.includes(:user).created_on(@date).page(params[:page])
  end

  def file
    @day = (params[:day] || (Time.zone || Time).now.day).to_i
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @date = Date.new(@year, @month, @day)
    @document_cameras = DocumentCamera.includes(:user).created_on(@date)
    response.header['Content-Type'] = 'text/csv; charset=shift_jis'
    response.header['Content-Disposition'] = "attachment; filename=document-camera-#{@year}-#{@month}-#{@date.day}.csv"
  end

  def show
  end
end
