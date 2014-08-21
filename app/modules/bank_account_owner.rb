module BankAccountOwner
  def self.included(base)
    base.has_one :bank_account, :as => :owner, :dependent => :destroy
    base.has_one :yucho_account_application, :foreign_key => :user_id
    base.attr_accessible :yucho_account_application
  end


  def create_account_of_bank(bank_code, params)
    transaction do
      bank = Bank.find_by_code(bank_code)
      account = bank.create_account(params)
      create_bank_account(bank: bank, account: account)
    end
  end

  def yucho_account
    if bank_account.present?
      account = bank_account.account
      if account.is_a? YuchoAccount
        account
      end
    end
  end


  ### 支払方法変更申込

  def create_yucho_account_appilcation_with(temp_yucho_account)
    if yucho_account_application.blank?
      self.yucho_account_application = YuchoAccountApplication.create(
        user: self,
        temp_yucho_account: temp_yucho_account
      )
    else
      self.yucho_account_application.destroy
      self.yucho_account_application = YuchoAccountApplication.create(
        user: self,
        temp_yucho_account: temp_yucho_account
      )
#      unless yucho_account_application.new?
#        self.yucho_account_application.destroy
#        self.yucho_account_application = YuchoAccountApplication.create(
#          user: self,
#          temp_yucho_account: temp_yucho_account
#        )
#      else
#        false
#      end
    end
  end


  # 承認
  def on_yucho_account_application_accepted
    self.payment_method = YuchoPayment.new
    replace_yucho_account(yucho_account_application.temp_yucho_account)
    # 支払方法変更完了メールの送信
    Mailer.send_mail(:payment_method_changed, self)
  end

  # 拒否
  def on_yucho_account_application_rejected
    # ゆうちょへの支払方法変更拒否メールを送信
    Mailer.send_mail(:yucho_account_application_rejected, self)
  end

  private

    # temp_yucho_accountの中身をyucho_accountに移す
    def replace_yucho_account(temp_yucho_account)
      if bank_account.present?
        if bank_account.account_type == YuchoAccount.name
          yucho = bank_account.account
          yucho.kigo1 = temp_yucho_account.kigo1
          yucho.kigo2 = temp_yucho_account.kigo2
          yucho.bango = temp_yucho_account.bango
          yucho.account_holder_name = temp_yucho_account.account_holder_name
          yucho.account_holder_name_kana = temp_yucho_account.account_holder_name_kana
          yucho.save!
        else
          return false
        end
      else
        yucho_params = {
          kigo1: temp_yucho_account.kigo1,
          kigo2: temp_yucho_account.kigo2,
          bango: temp_yucho_account.bango,
          account_holder_name: temp_yucho_account.account_holder_name,
          account_holder_name_kana: temp_yucho_account.account_holder_name_kana
        }
        create_account_of_bank("yucho", yucho_params)
      end
    end

end