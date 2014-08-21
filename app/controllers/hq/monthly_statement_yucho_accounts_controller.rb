class Hq::MonthlyStatementYuchoAccountsController < ApplicationController
  hq_user_only
  include HqUserAccessControl
  access_control :accounting

  before_filter do
    @monthly_statement = MonthlyStatement.find(params[:monthly_statement_id])
  end

  def index
    
  end
end
