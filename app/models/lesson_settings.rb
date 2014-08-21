class LessonSettings < ActiveRecord::Base
  attr_accessible :dropout_limit,
                  :student_entry_period_after_end_time,
                  :student_entry_period_before_start_time,
                  :tutor_entry_period_after_start_time,
                  :tutor_entry_period_before_start_time,
                  :request_time_limit,
                  :max_units,
                  :max_units_of_basic_lesson,
                  :message_to_tutor,
                  :period_to_close_room_after_end_time,
                  :beginner_tutor_lessons_limit

  class TimeBreakdownForUnits
    def initialize(lesson_settings, units)
      @lesson_settings = lesson_settings
      @units = units
    end

    attr_reader :units

    def lesson
      @lesson ||= @lesson_settings.duration_per_unit * units
    end

    def rest
      @lest ||= @lesson_settings.break_time_length * (units - 1)
    end

    def preparation
      @preparation ||= @lesson_settings.tutor_entry_period_before_start_time
    end

    def max_delay
      @max_delay ||= @lesson_settings.tutor_entry_period_after_start_time
    end

    def cool_down
      @cool_down ||= @lesson_settings.period_to_close_room_after_end_time
    end

    def total
      @total ||= lesson + rest + max_delay + cool_down
    end
  end

  class << self
    def instance
      last || create!
    end

    def init
      items = attribute_names.map(&:to_sym).select{|attr| attr != :id}
      self.class.delegate *items, to: :instance
    end

    def update(params)
      new_instance = instance.dup
      new_instance.update_attributes(params)
    end

    # レッスン予約を承諾可能な時間幅
    # 10分もしくはそれ以下
    # 仮にレッスン予約可能な時間幅が10分以下の場合はそれに合わせる。
    def request_acceptance_time_limit
      [10, request_time_limit].min
    end

    def minimum_time_range
      instance.breakdown_for_units(1).total
    end
  end

  init

  validates_numericality_of :tutor_entry_period_before_start_time,   greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  validates_numericality_of :tutor_entry_period_after_start_time,    greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  validates_numericality_of :student_entry_period_before_start_time, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  #validates_numericality_of :student_entry_period_after_start_time,  greater_than_or_equal_to: 0, less_than_or_equal_to: 55
  validates_numericality_of :student_entry_period_after_end_time, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  validates_numericality_of :dropout_limit, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  validates_numericality_of :max_units, greater_than_or_equal_to: 2, less_than_or_equal_to: 20
  validates_numericality_of :period_to_close_room_after_end_time, greater_than_or_equal_to: 0, less_than_or_equal_to: 10

  after_update :reset_lesson_time_events, if: :time_settings_changed?

  def break_time_length
    5
  end

  def breakdown_for_units(units)
    TimeBreakdownForUnits.new(self, units)
  end

  private

    def time_settings_changed?
      tutor_entry_period_before_start_time_changed? ||
      tutor_entry_period_after_start_time_changed? ||
      dropout_limit_changed?
    end

    def reset_lesson_time_events
      Lesson.delay.reset_door_keeping_jobs
    end
end
