### ゆうちょへの支払方法変更申込を管理するモデル
class YuchoAccountApplication < MembershipApplication
  # MembershipApplicationとの切り分け
  default_scope where(type: self.name)

  scope :only_new, where(status: 'new')

  # TempYuchoAccountで申込中の支払情報を持つ
  has_one :temp_yucho_account, :foreign_key => :yucho_account_application_id
  #belongs_to :user, :class_name => self.class.name, :polymorphic => true
  attr_accessible :temp_yucho_account

  def switching?
  	true #=> このクラスが使用される時点で支払方法変更である。
  end

  private

  	# 申込中のユーザーがBankAccountを持つ必要はない。
    def user_has_bank_account
    	true
    end

    # 申込承認時に呼ばれる
    def on_being_accepted
      user.on_yucho_account_application_accepted
    end
    
    # 申込拒否時に呼ばれる
    def on_rejected
      user.on_yucho_account_application_rejected
    end

    # 申込時に呼ばれる
    def on_created
      # 申込完了メールの送信
      Mailer.send_mail(:yucho_account_application_created, user)
    end
end