class Hq::YuchoPaymentsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  layout 'with_sidebar'

  def monthly
    @year = params[:year].to_i
    @month = params[:month].to_i
    @hq_yucho_payments = HqYuchoPayment.of_month(@year, @month).page(params[:page])
  end

  def file
    @year = params[:year].to_i
    @month = params[:month].to_i
    yas = YuchoAccountService.new
    filepath = yas.payments_file_of_month(@year, @month)
    respond_to do |format|
      format.csv do
        if File.exist?(filepath)
          send_file filepath, filename: "jpb-auto-receipts-#{@year}-#{@month}.csv"
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
      s = YuchoPaymentService.new
      s.make_payments_for_month(@year, @month)
    end
    redirect_to action: :monthly
  end
end
