# coding: utf-8

module TutorsHelper
  def tutor_name_label
    if user_signed_in?
      if current_user.hq_user?
        Tutor.human_attribute_name :full_name
      else
        Tutor.human_attribute_name :nickname
      end
    else
      Tutor.human_attribute_name :nickname
    end
  end

  def tutor_type(tutor)
    if tutor.is_a?(Tutor)
      if tutor.special?
        t('tutor.types.special')
      elsif tutor.beginner?
        t('tutor.types.beginner')
      else
        t('tutor.types.regular')
      end
    elsif tutor.is_a?(String)
      case tutor
      when 'RegularTutor' then t('tutor.types.regular')
      when 'BeginnerTutor' then t('tutor.types.beginner')
      when 'SpecialTutor' then t('tutor.types.special')
      else
        t('tutor.types.no_select')
      end
    end
  end

  def tutor_graduated_label(tutor)
    if tutor.special?
      t('tutor.special')
    else
      tutor.graduated? ? t('common.graduated') : t('common.not_graduated')
    end
  end

  def tutor_available_wdays(tutor)
    if tutor.weekday_schedules_count == 0
      t('tutor.weekday_schedules.all_days')
    else
      tutor.available_weekdays.map{|w| wday(w)}.join(', ')
    end
  end

  def tutor_average_cs_points(tutor)
    if tutor.info.average_cs_points.present?
      '%.1f' % tutor.info.average_cs_points
    end
  end

  def tutor_lesson_unit_wage_for_grade(tutor, grade)
    tutor.lesson_unit_wage_for_grade(grade)
  end

  def tutor_status(tutor)
    if tutor.special?
      t('tutor.regular_labels.special')
    elsif tutor.beginner?
      t('common.beginner')
    else
      t('tutor.regular_labels.regular')
    end
  end

  def tutor_auto_membership_losing_days_count(tutor)
    SystemSettings.tutor_max_absent_days - tutor.absent_days
  end

  def tutor_current_sign_in_date(tutor)
    if tutor.current_sign_in_at
      l tutor.current_sign_in_at.to_date, format: :year_month_day2
    else
      '-'
    end
  end

  def tutor_college(tutor)
    tutor_college_field tutor, :college
  end

  def tutor_department(tutor)
    tutor_college_field tutor, :department
  end

  def tutor_faculty(tutor)
    tutor_college_field tutor, :faculty
  end

  def tutor_graduate_college(tutor)
    tutor_college_field tutor, :graduate_college
  end

  def tutor_graduate_college_department(tutor)
    tutor_college_field tutor, :graduate_college_department
  end

  def tutor_major(tutor)
    tutor_college_field tutor, :major
  end

  def tutor_nickname(tutor)
    m = Regexp.new(I18n.t('tutor.nickname_pattern')).match(tutor.nickname)
    if m
      tutor.nickname
    else
      I18n.t('tutor.nickname_format', nickname: tutor.nickname)
    end
  end

  private

    def tutor_college_field(tutor, field_name)
      field = tutor.send field_name
      if field.present?
        m = Regexp.new(t("tutor.#{field_name}_name_pattern")).match(field)
        if m
          field
        else
          t("tutor.#{field_name}_name_format", field_name => field)
        end
      end
    end
end