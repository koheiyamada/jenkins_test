module StudentAccessControl
  def self.included(base)
    base.before_filter :check_if_ready_to_pay
  end

  private

    def check_if_ready_to_pay
      return if current_user.hq_user? # 代理登録
      if current_user.present?
        unless current_user.ready_to_pay?
          redirect_to new_st_payment_method_path
        end
      end
    end
end