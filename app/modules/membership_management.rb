module MembershipManagement
  def self.included(base)
    base.has_one :membership_application, foreign_key: :user_id, dependent: :destroy
  end

  # 申込を本部が承諾したときに呼び出される。
  # 登録完了となる
  ### ！追記：支払方法にYuchoPaymentを代入する。
  ### また、支払方法変更申込であった場合、変更完了した旨をメールで送信する。
  def on_membership_application_accepted(membership_application)
    self.payment_method = YuchoPayment.new
    unless active?
      on_registration_completed
    else
      if customer_type == "request_to_premium"
        self.to_premium
        minor_student_to_premium
        Mailer.send_mail(:premium_registration_with_yucho, self)
      end
    end
    save
  end

  def on_membership_application_rejected(membership_application)
    # 従来通りの申込の場合
    unless active?
      # アカウントを削除する
      self.destroy
    # 無料会員からの申込の場合
    else
      # 無料会員に戻す
      self.customer_type = 'free'
      minor_student_stay_free
      self.save
    end
  end

  # クレジットカードの登録後に呼び出される
  # 登録作業中の場合は登録完了となる
  ### ！追記：支払方法にCreditCardPaymentを代入する。
  def on_credit_card_registered
    self.payment_method = CreditCardPayment.new
    if new?
      on_registration_completed
    else
      if self.free?
        self.to_premium
        # クレジットカードで一般会員登録した会員に送るメール
        Mailer.send_mail(:premium_registration_with_credit_card, self)
      else
        # 支払方法を変更した会員に送るメール
        Mailer.send_mail(:payment_method_changed, self)
      end
    end
    save
  end

  # 無料化する前の登録完了処理を呼ぶ
  def traditional_registration
    on_registration_completed
  end

  ######## 無料会員登録処理

  ######無料会員アクティベート
  def activate_free
    self.status = 'active'
    self.active = true
    self.to_free
    save.tap do |success|
      logger.info "FreeUser #{id} is activated." if success
    end
  end

  ######無料会員登録処理
  def free_registration
    activate_free
      if errors.empty?
        # アカウント作成時のパスワードがこの時点では不明となっているため、
        # ここで再設定する。
        reset_password
        notify_created
        true
      else
        false
     end
  end

  ###########################
  ### 無料会員・一般会員切り替え
  ###########################
  def to_free
    self.customer_type = "free"
    self.payment_method = DummyPaymentMethod.new
    touch(:date_of_becoming_free_user)
    self.free_lesson_limit_number = SystemSettings.free_lesson_limit_number
    self.free_lesson_expiration_date = SystemSettings.free_lesson_expiration_date
    save
    self
  end

  def to_premium
    self.customer_type = "premium"
    # to_premiumされていないユーザはenrollもしていないものとする
    self.enroll
    save
    self
  end

  def request_to_premium
    self.customer_type = "request_to_premium"
    save
    self
  end

  private

    # 保護者が一般会員登録申請している受講者を探して一般会員にする
    def minor_student_to_premium
      if self.parent?
        self.students.each do |student|
          if student.request_to_premium?
            student.to_premium
          end
        end
      end
    end

    # 保護者が一般会員登録申請している受講者を探して無料会員に戻す
    def minor_student_stay_free
      if self.parent?
        self.students.each do |student|
          if student.request_to_premium?
            student.customer_type = 'free'
            student.save
          end
        end
      end
    end

    # 登録完了時に呼び出す
    # 状態を'active'にする
    def on_registration_completed
      activate
      # ここを通る場合無料モードはオフなので必ずto_premiumしておく
      to_premium
      if errors.empty?
        # アカウント作成時のパスワードがこの時点では不明となっているため、
        # ここで再設定する。
        reset_password
        notify_created
        true
      else
        false
      end
    end

    def notify_created
      # 実装はインクルードしたクラス任せ
    end

end