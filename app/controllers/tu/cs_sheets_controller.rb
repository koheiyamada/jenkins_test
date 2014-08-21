class Tu::CsSheetsController < ApplicationController
  tutor_only
  layout 'with_sidebar'

  def index
    @cs_sheets = current_user.cs_sheets.page(params[:page])
  end

  def show
    @cs_sheet = current_user.cs_sheets.find(params[:id])
  end
end
