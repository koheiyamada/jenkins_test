class St::PaymentsController < ApplicationController
  include StudentAccessControl
  student_only
  #layout 'centered', :only => [:add_credit_card]
  layout 'with_sidebar', :except => [:show, :entry_fee_confirmation, :process_entry_fee_confirmation, :confirmation, :process_confirmation, :select_payment_method]#, :add_credit_card, :add_yubin_chokin]
  #before_filter :only_students_with_credit_card, :except => [:confirmation, :process_confirmation, :select_payment_method, :add_credit_card, :add_yubin_chokin]
  #before_filter :redirect_if_necessary, :only => [:show]
  def index
    @payments = []
  end

  def entry_fee_confirmation
    @entry_fee = SystemSettings.entry_fee
  end

  def process_entry_fee_confirmation
    agreement = params[:agreement] == '1'
    if agreement
      redirect_to action: :confirmation and return
    else
      @checkbox_validate = true
      @entry_fee = SystemSettings.entry_fee
      render action: :entry_fee_confirmation
    end
  end

  def confirmation
  end

  def process_confirmation
    has_payment_method = params[:has_payment_method] == '1'
    if has_payment_method
      redirect_to action: :select_payment_method
    else
      redirect_to st_root_path
    end
  end

  def select_payment_method
    session[:from_free_user] = true if current_user.free?
    params[:bank] = 'yucho'
    @bank_account = Bank.find_by_code(params[:bank]).new_account
  end


#処理を移譲したのでコメントアウト
=begin
  def add_credit_card
  end

  def add_yubin_chokin
  end

  def show
    if subject.bank_account.blank?
      redirect_to action: 'add_yubin_chokin'
    else
      @bank_account = subject.bank_account.account
      @bank = subject.bank_account.bank
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

  def new_template
    case params[:bank]
    when 'yucho' then :new_yucho
    when 'mitsubishi_tokyo_ufj' then :new_mitsubishi_tokyo_ufj
    else :new_bank
    end
  end

  private
  def only_students_with_credit_card
    unless current_user.has_credit_card?
      redirect_to st_root_path
    end
  end

  def redirect_if_necessary
    if current_user.new?
      if current_user.membership_application.present?
        redirect_to complete_st_membership_application_path
      end
    end
  end

  def subject
    current_user
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
    if bank_type == "yucho"
      unless current_user.customer_type == "premium"
        current_user.request_to_premium
      end
      build_membership_application
    else
      current_user.to_premium
    end
    if @bank_account.persisted?
      redirect_to action: 'show'
    else
      render new_template
    end
  end

  def build_membership_application
    @membership_application = current_user.build_membership_application
    @membership_application.save
  end
=end

end