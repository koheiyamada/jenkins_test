class Hq::Bss::BankAccountsController < BankAccountsController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  prepend_before_filter :prepare_bs

  def show
  	@from_hq_bss = true
  	@bank_account = subject.bank_account.account
    @bank = subject.bank_account.bank
  	render controller: :bank_accounts, action: :show
  end

  private

    def subject
      @bs
    end

end
