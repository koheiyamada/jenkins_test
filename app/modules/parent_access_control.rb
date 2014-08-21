module ParentAccessControl
  def self.included(base)
    base.before_filter :check_if_active
  end

  private

    def check_if_active
      if current_user.present?
        # 保護者は支払情報が登録されてはじめてactiveとなるので、
        # 支払準備ができている == activeと考えてよい。
        unless current_user.active?
          redirect_to new_pa_payment_path
        end
      end
    end
end