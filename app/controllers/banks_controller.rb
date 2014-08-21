class BanksController < ApplicationController
  layout 'with_sidebar'

  def index
    @banks = Bank.page(params[:page])
  end

  def new
    @bank = Bank.new
  end

  def create
    @bank = Bank.new(params[:bank])
    if @bank.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @bank = Bank.find(params[:id])
  end

  def update
    @bank = Bank.find(params[:id])
    if @bank.update_attributes(params[:bank])
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @bank = Bank.find(params[:id])
    if @bank.bank_accounts.empty?
      @bank.destroy
      redirect_to action: :index
    else
      redirect_to({action: :index}, alert: t('bank.messages.cannot_delete_because_bank_accounts_exist'))
    end
  end
end
