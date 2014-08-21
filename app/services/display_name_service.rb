# coding: utf-8

# ユーザーの表示方法を解決する
class DisplayNameService
  include Loggable

  # [見る人のアカウント種別][見られる人のアカウント種別] => 見られる人の名前表示に使うメソッド
  NAME_METHOD_MAP = {
    hq_user: {
      hq_user: :full_name,
      bs_user: :full_name,
      tutor:   :full_name,
      student: :full_name,
      parent:  :full_name
    },
    bs_user: {
      hq_user: :full_name,
      bs_user: :full_name,
      tutor:   :nickname2,  # BSにはチューターのニックネームを表示する
      student: :full_name,
      parent:  :full_name
    },
    tutor: {
      hq_user: :full_name,
      bs_user: :full_name,
      tutor:   :nickname2,  # チューターには他のチューターのニックネームを表示する
      student: :nickname,   # チューターには受講者のニックネームを表示する
      parent:  :nickname,   # チューターには保護者のニックネームを表示する
    },
    student: {
      hq_user: :full_name,
      bs_user: :full_name,
      tutor:   :nickname2,  # 受講者にはチューターのニックネームを表示する
      student: :nickname,   # 受講者には他の受講者のニックネームを表示する
      parent:  :full_name
    },
    parent: {
      hq_user: :full_name,
      bs_user: :full_name,
      tutor:   :nickname2,
      student: :nickname,
      parent:  :full_name
    },
    guest: {
      hq_user: :nickname,
      bs_user: :nickname,
      tutor:   :nickname2,
      student: :nickname,
      parent:  :nickname
    },
  }

  class << self
    def name_for_user_type(user, user_type)
      if user_type <= Student
        user.send NAME_METHOD_MAP[:student][user.role]
      elsif user_type <= Tutor
        user.send NAME_METHOD_MAP[:tutor][user.role]
      elsif user_type <= Parent
        user.send NAME_METHOD_MAP[:parent][user.role]
      elsif user_type <= BsUser
        user.send NAME_METHOD_MAP[:bs_user][user.role]
      elsif user_type <= Guest
        user.send NAME_METHOD_MAP[:guest][user.role]
      else
        user.full_name
      end
    end
  end

  # userは画面を見る人のアカウント
  def initialize(user)
    @user = user
  end

  attr_reader :user

  # 閲覧者向けの表示名を返す。
  # @param viewee 名前を表示される人
  def name(viewee)
    if viewee.nil? || user.nil?
      nil
    else
      if viewee == user
        I18n.t('common.me')
      else
        name_of(viewee) || user.full_name
      end
    end
  end

  def name_with_role(viewee)
    if viewee.present?
      '%s (%s)' % [name(viewee), role_name(viewee)]
    end
  end

  def role_name(viewee)
    I18n.t('common.' + viewee.type.underscore)
  end

  private

    def name_of(viewee)
      viewee.send NAME_METHOD_MAP[user.role][viewee.role]
    rescue => e
      logger.error e
      viewee.nickname
    end
end