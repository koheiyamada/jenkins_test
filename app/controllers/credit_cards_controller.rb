class CreditCardsController < ApplicationController
  def register
    if request.post?
      @credit_card = CreditCard.new(params[:credit_card])
      if @credit_card.valid?
        if current_user.credit_card_register(
            number: @credit_card.number,
            expire: "%02d/%02d" % [
              @credit_card.expire.month,
              @credit_card.expire.year,
            ],
            security_code: @credit_card.security_code)
          current_user.update_attribute(:has_credit_card, true)
          current_user.on_credit_card_registered
          # 受講者の一般会員登録からきた保護者だった場合、
          # セッションに保存されている受講者のIDを調べてそちらも一般会員にする
          if current_user.parent? && session[:student_id].present?
            student = current_user.students.find(session[:student_id])
            student.to_premium
          end
          redirect_to action:'registered'
        else
          @credit_card.errors.add :number, :authorize_failure
          render :register and return
        end
      end
    else
      @credit_card = CreditCard.new
    end
  end

  def registered
  end

  private

    # 処理の実行後にログインをし直す。
    # これは、クレジットカードに登録完了後、ユーザーに送るメールに含める
    # パスワードを得るためにパスワードを一度リセットしているため。
    # パスワードをリセットするとDeviseの仕組みとして一度ログアウトさせられる。
    def sign_in_again
      parent = current_user
      yield
      sign_in parent, :bypass => true
    end

    def layout_for_user
      current_user.new? ? 'registration-centered' : 'centered'
    end
end
