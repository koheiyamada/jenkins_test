class Pa::PaymentsController < ApplicationController
  parent_only
  layout 'centered'
  before_filter :redirect_if_necessary, :only => [:show]

  def show
    if current_user.has_credit_card?
      redirect_to pa_credit_card_path
    elsif current_user.bank_account.present?
      redirect_to pa_bank_account_path
    else
      redirect_to action: :new
    end
  end

  def new
    @payment_method = current_user.payment_method

    if @payment_method.present?
      if @payment_method.is_a? CreditCardPayment
        redirect_to pa_credit_card_path
      elsif @payment_method.is_a? YuchoPayment
        redirect_to pa_bank_account_path
      elsif @payment_method.is_a? DummyPaymentMethod
        redirect_to new_pa_free_registration_path
      end
    end
  end

  def entry_fee_confirmation
    if params[:id]
      session[:student_id] = params[:id]
    end
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
    if session[:student_id]
      check_if_already_premium_user(session[:student_id])
    end
  end

  def process_confirmation
    @has_payment_method = params[:has_payment_method] == '1'
    if @has_payment_method
      redirect_to action: :select_payment_method
    else
      redirect_to pa_root_path
    end
  end

  def select_payment_method
    session[:from_free_user] = true if current_user.free?
    params[:bank] = 'yucho'
    @bank_account = Bank.find_by_code(params[:bank]).new_account
  end

#未使用アクション
=begin
  def add_credit_card
  end

  def add_yubin_chokin
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
=end

  private
  def redirect_if_necessary
    if subject.membership_application.present?
      redirect_to complete_pa_membership_application_path
    end
  end

#未使用メソッド
=begin
  def subject
    current_user
  end

  def student
    current_user.students.find(session[:student_id])
  end

  def student_to_premium
    student.to_premium if student.present?
  end

  def student_request_to_premium
    student.request_to_premium if student.present?
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
        subject.request_to_premium
        student_request_to_premium
      end
      build_membership_application
    else
      subject.to_premium
      student_to_premium
    end
    if @bank_account.persisted?
      redirect_to action: 'show'
    else
      render new_template
    end
  end

  def build_membership_application
    @membership_application = subject.build_membership_application
    @membership_application.save
  end
=end

  def check_if_already_premium_user(student_id)
    student = User.find(student_id)
    if current_user.premium?
      student.to_premium
      redirect_to pa_students_path and return
    elsif current_user.request_to_premium?
      student.request_to_premium
      redirect_to pa_students_path and return
    end
  end

end
