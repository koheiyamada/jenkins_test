class Pa::BankAccountsController < YuchoAccountsController
  parent_only
  layout 'registration-centered'

  before_filter :redirect_if_necessary, :only => :complete

  def show
    if subject.bank_account.blank?
      redirect_to action: 'new' and return
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

  def complete
    if current_user.membership_application.switching?
    end
  end

  private

    def redirect_if_necessary
      if current_user.new?
        if current_user.membership_application.present?
          redirect_to complete_pa_membership_application_path
        end
      end
    end

    def create_bank_account(bank_type)
      bank_account = subject.create_account_of_bank(bank_type, params[:bank_account])
      @bank_account = bank_account.account
      @bank = Bank.find_by_code bank_type
      if bank_type == "yucho"
        unless current_user.customer_type == "premium"
          current_user.request_to_premium
          student_request_to_premium
        end
        build_membership_application
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

    def student
      if current_user.active? && session[:student_id].present?
        current_user.students.find(session[:student_id])
      end
    end

    def student_to_premium
      student.to_premium if student.present?
    end

    def student_request_to_premium
      student.request_to_premium if student.present?
    end
end
