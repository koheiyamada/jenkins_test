class CsSheetsController < ApplicationController
  layout 'with_sidebar'

  def index
    @cs_sheets = current_user.cs_sheets.for_list.order("created_at DESC").page(params[:page])
  end

  def show
    @cs_sheet = current_user.cs_sheets.find(params[:id])
  end
end
