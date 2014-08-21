module LessonsHelper
  def lesson_name(lesson)
    t("common.lesson_name", subject:lesson.name, time:l(lesson.start_time, :format => :short))
  end

  def lesson_schedule_for_student(lesson)
    I18n.t('lesson.schedule_and_tutor',
           day:   I18n.l(lesson.date, format: :month_day2),
           from:  I18n.l(lesson.start_time, format: :only_time2),
           to:    I18n.l(lesson.end_time, format: :only_time2),
           tutor: lesson.tutor.nickname)
  end

  def lesson_type(lesson)
    t("common.lesson_types.#{lesson.class.name}")
  end

  def lesson_style(lesson)
    t("lesson.styles.#{lesson.style}")
  end

  def lesson_status(lesson)
    if current_user.student?
      if lesson.student_cancelled?(current_user)
        t('lesson_status.cancelled')
      else
        t("lesson_status.#{lesson.status}")
      end
    else
      t("lesson_status.#{lesson.status}")
    end
  end

  def lesson_extension(lesson)
    lesson.extended? ? t('common.existent') : t('common.non_existent')
  end

  def lesson_time_range(lesson)
    content_tag(:div) do
      content_tag(:span, class:"date") do
        l(lesson.start_time.to_date)
      end + " " +
      content_tag(:span, class:"time-range") do
        content_tag(:span, class:"start-time") do
          l(lesson.start_time, :format => :only_time)
        end +
        ' - ' +
        content_tag(:span, class:"end-time") do
          l(lesson.end_time, :format => :only_time)
        end
      end
    end
  end

  def lesson_can_monitor_now?(lesson)
    monitoring = LessonMonitoring.new(lesson)
    monitoring.can_monitor_now?
  end

  def lesson_cancellation_reason(lesson, student)
    c = lesson.student(student).lesson_cancellation
    if c.present?
      c.reason.present? ? c.reason : t('common.no_reason')
    else
      t('common.no_reason')
    end
  end

  def month_link(month_date, opts=nil)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year}, opts)
  end
  
  # custom options for this calendar
  def event_calendar_opts
    {
        :year => @year,
        :month => @month,
        :event_strips => @event_strips,
        :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
        :previous_month_text => month_link(@shown_month.prev_month, class:"navi_left"),
        :next_month_text => month_link(@shown_month.next_month, class:"navi_right")    }
  end

  def lesson_calendar(&block)
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      lesson = args[:event]
      lesson_path = yield lesson
      name = lesson_name_for_calendar(lesson)
      %(<a href="#{lesson_path}" title="#{h(name)}" target="_top">#{h(name)}</a>)
    end
  end

  def lesson_name_for_calendar(lesson)
    name = current_user.tutor? ? lesson.students.map(&:nickname).join(',') : lesson.tutor_nickname
    '%{time} %{name}' % {name: name, time: l(lesson.start_time, :format => :only_time)}
  end

  def available_times_calendar
    calendar event_calendar_opts do |args|
      available_time = args[:event]
      s = yield available_time
      s
      #%(<a href="#{lesson_path}" title="#{h(lesson.name)}" target="_top">#{h(lesson.name)}</a>)
    end
  end

  def desk_width
    720
  end

  def desk_height
    540
  end

  def lesson_video_channel(lesson, user)
    "aid-lesson-#{lesson.id}-#{user.id}"
  end

  def lesson_document_camera_channel(lesson, user)
    "aid-lesson-#{lesson.id}-#{user.id}-document_camera"
  end
end
