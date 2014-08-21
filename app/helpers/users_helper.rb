module UsersHelper
  def user_display_name(user, target=default_target)
    DisplayNameService.new(target).name(user)
  end

  def user_nickname(user)
    if user.nickname.present?
      user.tutor? ? tutor_nickname(user) : user.nickname
    else
      user.full_name
    end
  end

  def user_display_name_with_role(user)
    if user.present?
      '%s (%s)' % [user_display_name(user), user_type(user)]
    end
  end

  def user_display_name_with_role_for_user_type(user, user_type)
    name = DisplayNameService.name_for_user_type(user, user_type)
    '%s (%s)' % [name, user_type(user)]
  end

  def user_image(user, options={})
    if user.present? && user.photo?
      image_tag(user.photo_url, options)
    else
      image_tag('anonymous.png', options)
    end
  end

  def user_image_anonymous(options={})
    image_tag('anonymous.png', options)
  end

  def user_type(user)
    I18n.t('common.' + user.type.underscore)
  end

  def user_type_string(user_type)
    I18n.t('common.' + user_type.underscore)
  end

  def user_organization(user)
    user.organization && user.organization.name
  end

  def user_age(user)
    case user.age
    when nil then '-'
    when 0...20 then t('common.less_than_20_year_old')
    when 20...30 then t('common.twenties')
    when 30...40 then t('common.thirties')
    else t('common.more_than_40')
    end
  end

  def user_name(user)
    if user.nil?
      nil
    elsif current_user
      if current_user.hq_user? || current_user == user || current_user.parent_of?(user)
        user.user_name
      else
        '********'
      end
    else
      '********'
    end
  end

  def user_can_see_user_name?(user)
    if user.nil?
      false
    else
      if current_user.present?
        current_user.hq_user? || current_user == user || current_user.parent_of?(user)
      else
        false
      end
    end
  end

  def user_payment_method(payment_method)
    if payment_method.present?
      eval(payment_method.type).model_name.human
    else
      nil
    end
  end

  def hq_user?
    current_user.hq_user?
  end

  def tutor?
    current_user.tutor?
  end

  def coach?
    current_user.coach?
  end

  def student?
    current_user.student?
  end

  def parent?
    current_user.parent?
  end

  def user_page_path(user)
    url_for(controller: user.class.name.underscore.pluralize, action: :show, id: user)
  end

  def member_only
    content_tag :span, t('messages.member_only2'), class: 'member_only'
  end

  private

    def default_target
      defined?(current_user) ? current_user : nil
    end
end