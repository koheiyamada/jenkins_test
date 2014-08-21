class Hq::YuchoAccountsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  layout 'with_sidebar'

  def index
    @yucho_accounts = YuchoAccount.page(params[:page])
  end

  def monthly
    if params[:year] && params[:month]
      @year = params[:year].to_i
      @month = params[:month].to_i
    else
      redirect_to year: Date.today.year, month: Date.today.month
    end
  end

  def students

  end

  def tutors

  end

  def bss

  end

  def payments
    @year = params[:year].to_i
    @month = params[:month].to_i
    @yucho_accounts = YuchoAccount.page(params[:page])
    yas = YuchoAccountService.new
    filepath = yas.billings_file_of_month(@year, @month)
    unless File.exist?(filepath)
      YuchoAccount.delay.compile_payments_file_of_month(@year, @month)
    end
    respond_to do |format|
      format.html
      format.csv do
        if File.exist?(filepath)
          send_file filepath, filename: "yucho-payments-#{@year}-#{@month}.csv"
        else
          redirect_to({action: :payments}, alert: t('yucho_account.file_not_ready'))
        end
      end
    end
  end

  def receipts
    @year = params[:year].to_i
    @month = params[:month].to_i
    @yucho_accounts = YuchoAccount.page(params[:page])
    yas = YuchoAccountService.new
    filepath = yas.payments_file_of_month(@year, @month)
    unless File.exist?(filepath)
      YuchoAccount.delay.compile_recipients_file_of_month(@year, @month)
    end
    respond_to do |format|
      format.html
      format.csv do
        if File.exist?(filepath)
          send_file filepath, filename: "yucho-recipients-#{@year}-#{@month}.csv"
        else
          redirect_to({action: :receipts}, alert: t('yucho_account.file_not_ready'))
        end
      end
    end
  end

  def billings
    @year = params[:year].to_i
    @month = params[:month].to_i
    @yucho_billings = YuchoBilling.of_month(@year, @month).page(params[:page])
    respond_to do |format|
      format.html
      format.csv do
        if File.exist?(filepath)
          send_file filepath, filename: "yucho-recipients-#{@year}-#{@month}.csv"
        else
          redirect_to({action: :receipts}, alert: t('yucho_account.file_not_ready'))
        end
      end
    end
  end
end
