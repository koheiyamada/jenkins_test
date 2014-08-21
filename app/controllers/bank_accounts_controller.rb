class BankAccountsController < ApplicationController
  layout 'with_sidebar'
  #before_filter :check_subject_does_not_have_bank_account, :only => [:new, :create]

  def show
    if subject.bank_account.blank?
      redirect_to action: 'new'
    else
      @bank_account = subject.bank_account.account
      @bank = subject.bank_account.bank
    end
  end

  def new
    if params[:bank]
      bank = Bank.find_by_code(params[:bank])
      if bank.present?
        @bank_account = Bank.find_by_code(params[:bank]).new_account
        @bank = Bank.find_by_code params[:bank]
        render new_template
      else
        # General Bank Account
        @bank_account = GeneralBankAccount.new
        render :new_account
      end
    else
      @bank_account = subject.bank_account
      @banks = Bank.all
    end
  end

  def create
    bank_type = params[:bank]
    if bank_type == 'other'
      create_general_bank_account
    else
      create_bank_account(bank_type)
    end
  end

  def edit
    @bank_account = subject.bank_account.account
  end

  def update
    @bank_account = subject.bank_account.account
    if @bank_account.update_attributes(params[:bank_account])
      redirect_to action: 'show'
    else
      render action: 'edit'
    end
  end

  private

    def check_subject_does_not_have_bank_account
      if subject.bank_account.present?
        redirect_to action: 'show'
      end
    end

    def subject
      current_user
    end

    def layout_for_user
      current_user.new? ? 'registration-centered' : 'with_sidebar'
    end

    def new_template
      case params[:bank]
      when 'yucho' then :new_yucho
      when 'mitsubishi_tokyo_ufj' then :new_mitsubishi_tokyo_ufj
      else :new_bank
      end
    end

    def create_general_bank_account
      s = BankAccountService.new(subject)
      s.create_general_bank_account!(params[:bank_account])
      redirect_to action: :show
    rescue => e
      logger.error e
      @bank_account = e.record if e.respond_to? :record
      render :new_account
    end

    def create_bank_account(bank_type)
      bank_account = subject.create_account_of_bank(bank_type, params[:bank_account])
      @bank_account = bank_account.account
      @bank = Bank.find_by_code bank_type
      if @bank_account.persisted?
        redirect_to action: 'show'
      else
        render new_template
      end
    end
end
