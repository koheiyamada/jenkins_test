# coding:utf-8

class SobaChargeService

  class << self
    def print_account_for_license_fee(year, month)
      accounts_for_license_fee(year, month) do |user|
        puts "#{user.id},#{user.user_name},#{user.type},#{user.full_name}"
      end
    end

    def enumerate_accounts_for_license_fee(year, month)
      MonthlyChargingUser.transaction do
        MonthlyChargingUser.clear(year, month)
        accounts_for_license_fee(year, month) do |user|
          MonthlyChargingUser.create do |u|
            u.user_id = user.id
            u.year = year
            u.month = month
            u.user_type = user.type
            u.user_name = user.user_name
            u.full_name = user.full_name
          end
        end
      end
    end

    def accounts_for_license_fee(year, month, &block)
      instance = new

      HqUser.find_each do |user|
        if instance.account_to_charge?(user, year, month)
          block.(user)
        end
      end

      t = Time.new(year, month)

      Student.where("status = 'active' || left_at > ?", 1.month.ago(t)).find_each do |user|
        if instance.account_to_charge?(user, year, month)
          block.(user)
        end
      end

      Tutor.where("status = 'active' || left_at > ?", 1.month.ago(t)).find_each do |user|
        if instance.account_to_charge?(user, year, month)
          block.(user)
        end
      end

      BsUser.where("status = 'active' || left_at > ?", 1.month.ago(t)).find_each do |user|
        if instance.account_to_charge?(user, year, month)
          block.(user)
        end
      end
    end
  end

  # 以下の条件をすべて満たす場合trueを返す
  # - 期間末日が入会日から31日後かそれ以降である
  # - 期間中アカウントが有効だった <=> 現在アカウントが有効である || (退会日が期間初日以降 && 退会日が入会日から31日後かそれ以降)
  # - 最終ログイン日が期間初日以降
  def account_to_charge?(user, year, month)
    range = DateUtils.period_of_settlement_month(year, month)
    first_day = range.first
    last_day = range.last
    enough_days_since_enrollment(user, last_day) &&
    active_in_period?(user, range) &&
    signed_in_after?(user, first_day) &&
    charging_user?(user)
  end

  def license_charge_count(user, year, month)
    account_to_charge?(user, year, month) ? 1 : 0
  end

  private

  def enough_days_since_enrollment(user, day)
    if user.student?
      user.enrolled_at.present? && user.enrolled_at < 30.days.ago(day).to_time
    else
      true
    end
  end

  # 期間中アカウントが有効だったらtrueを返す
  # <=> 現在アカウントが有効である || (退会日が期間初日以降 && 退会日が入会日から31日後かそれ以降)
  def active_in_period?(user, day_range)
    user.active? || (left_in_period?(user, day_range) && left_after_moratorium?(user))
  end

  def left_in_period?(user, day_range)
    user.left_at >= day_range.first.to_time
  end

  def left_after_moratorium?(user)
    user.left_at >= 31.days.since(user.registered_day).to_time
  end

  def signed_in_after?(user, day)
    user.current_sign_in_at.present? && (user.current_sign_in_at >= day.beginning_of_day)
  end

  def charging_user?(user)
    !no_charging_user_ids.include?(user.id)
  end

  def no_charging_user_ids
    @no_charging_user_ids ||= NoChargingUser.scoped.pluck(:user_id)
  end
end