# coding:utf-8
class TutorReferenceService
  include Loggable
  REFERENCE_ROLES = %w(Tutor SpecialTutor BsUser Coach HqUser)

  def initialize(tutor)
    @tutor = tutor
  end

  attr_reader :tutor

  def pay
    if tutor.reference.present?
      pay_to_reference(tutor.reference)
    else
      false
    end
  end

  # このチューターの紹介者としてuser_nameのアカウントを指定する
  # チューター、BSオーナー、本部アカウントを指定できる。
  # それ以外のタイプのアカウントや存在しないアカウント名が与えられた場合は何もしない。
  # 紹介者を指定した場合はそのアカウントを返す。
  # それ以外の場合はnilを返す
  def assign_reference(user_name)
    reference = User.find_by_user_name user_name
    if reference.present?
      if REFERENCE_ROLES.include? reference.type
        tutor.reference = reference
      end
    end
  end

  private

    def pay_to_reference(reference)
      reference.tutor_referral_fees.create(referral: tutor)
      logger.info "TUTOR REFERENCE FEE WAS PAID TO #{reference.id} FOR #{tutor.id}"
    end
end