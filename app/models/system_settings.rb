class SystemSettings < ActiveRecord::Base

  class << self
    def cs_point_visible?
      instance.cs_point_visible
    end

    def free_mode?
      instance.free_mode
    end
    
    def instance
      first
    end

    def setting_items
      @setting_items ||= attribute_names.map(&:to_sym).select{|attr| attr != :id}
    end

    delegate *SystemSettings.setting_items, to: :instance

    def hq_user_reference_discount_rate
      0.05
    end

    def network_friendly?
      false
    end

    def document_camera_fps_field_options
      if network_friendly?
        {min: 1, max: 10, step: 1}
      else
        {min: 1, step: 1}
      end
    end

    def document_camera_bandwidth_field_options
      if network_friendly?
        {min: 0, max: 50000, step: 1}
      else
        {min: 0, step: 1}
      end
    end

    def video_fps_field_options
      if network_friendly?
        {min: 1, max: 10, step: 1}
      else
        {min: 1, step: 1}
      end
    end

    def video_bandwidth_field_options
      if network_friendly?
        {min: 0, max: 50000, step: 1}
      else
        {min: 0, step: 1}
      end
    end

    def meeting_video_fps_field_options
      if network_friendly?
        {min: 1, max: 10, step: 1}
      else
        {min: 1, step: 1}
      end
    end

    def meeting_video_bandwidth_field_options
      if network_friendly?
        {min: 0, max: 50000, step: 1}
      else
        {min: 0, step: 1}
      end
    end

    def tutor_max_absent_days
      90
    end

    def tutor_warning_absent_days
      85
    end

    def hour_range_for_sending_mail
      (7 .. 21)
    end

    def aid_phone_number
      '075-253-5555'
    end

    def max_message_files_count
      3
    end
  end

  attr_accessible *setting_items

  validate do
    if new_record? && SystemSettings.count > 0
      raise "no more instance"
    end
  end

  validates_numericality_of :entry_fee, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10**8
  validates_numericality_of :default_max_charge, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10**8
  validates_numericality_of :message_storage_period, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_numericality_of :bs_share_of_lesson_sales, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
  validates_numericality_of :tutor_share_of_lesson_fee, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
  validates_numericality_of :tax_rate, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
  validates_numericality_of :max_coach_count_for_area, :greater_than_or_equal_to => 0

  if network_friendly?
    validates_numericality_of :document_camera_fps, :only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10
    validates_numericality_of :document_camera_bandwidth, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 50000
    validates_numericality_of :document_camera_quality, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

    validates_numericality_of :video_fps, :only_integer => true, :greater_than_or_equal_to => 1 , :less_than_or_equal_to => 15
    validates_numericality_of :video_bandwidth, :only_integer => true, :greater_than_or_equal_to => 0 , :less_than_or_equal_to => 50000
    validates_numericality_of :video_quality, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

    validates_numericality_of :meeting_video_fps, :only_integer => true, :greater_than_or_equal_to => 1 , :less_than_or_equal_to => 15
    validates_numericality_of :meeting_video_bandwidth, :only_integer => true, :greater_than_or_equal_to => 0 , :less_than_or_equal_to => 50000
    validates_numericality_of :meeting_video_quality, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  else
    validates_numericality_of :document_camera_fps, :only_integer => true, :greater_than_or_equal_to => 1
    validates_numericality_of :document_camera_bandwidth, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :document_camera_quality, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

    validates_numericality_of :video_fps, :only_integer => true, :greater_than_or_equal_to => 1
    validates_numericality_of :video_bandwidth, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :video_quality, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

    validates_numericality_of :meeting_video_fps, :only_integer => true, :greater_than_or_equal_to => 1
    validates_numericality_of :meeting_video_bandwidth, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :meeting_video_quality, :only_integer => true, :greater_than_or_equal_to => 0
  end

  validates_numericality_of :document_camera_width, :only_integer => true, :greater_than_or_equal_to => 160, :less_than_or_equal_to => 1600
  validates_numericality_of :document_camera_height, :only_integer => true, :greater_than_or_equal_to => 120, :less_than_or_equal_to => 1200

  validate :ensure_sum_of_share_is_less_than_one

  after_update :reset_lesson_door_keeping_jobs, if: :lesson_delay_limit_changed?

  private

    def ensure_sum_of_share_is_less_than_one
      if bs_share_of_lesson_sales + tutor_share_of_lesson_fee > 1
        errors.add :bs_share_of_lesson_sales, :sum_of_share_is_over_one
      end
    end

    def reset_lesson_door_keeping_jobs
      Lesson.delay.reset_door_keeping_jobs
    end
end
