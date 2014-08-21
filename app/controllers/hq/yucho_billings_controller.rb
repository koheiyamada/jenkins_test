class Hq::YuchoBillingsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  layout 'with_sidebar'

  def monthly
    @year = params[:year].to_i
    @month = params[:month].to_i
    @yucho_billings = YuchoBilling.of_month(@year, @month).page(params[:page])
  end

  def file
    @year = params[:year].to_i
    @month = params[:month].to_i
    yas = YuchoAccountService.new
    filepath = yas.billings_file_of_month @year, @month
    respond_to do |format|
      format.csv do
        if File.exist?(filepath)
          send_file filepath, filename: "jpb-auto-payments-#{@year}-#{@month}.csv"
        else
          redirect_to({action: :monthly, year: @year, month: @month}, alert: t('yucho_account.file_not_ready'))
        end
      end
    end
  end

  def calculate
    if params[:year] && params[:month]
      @year = params[:year].to_i
      @month = params[:month].to_i
      s = YuchoBillingService.new
      s.make_billings_for_month(@year, @month)
    end
    redirect_to action: :monthly
  end

end
