class AccessAuthority < ActiveRecord::Base
  class << self
    def admin
      new do |a|
        a.accounting = 2
        a.bs_user = 2
        a.cs_sheet = 2
        a.lesson_report = 2
        a.parent = 2
        a.tutor = 2
        a.student = 2
        a.hq_user = 2
      end
    end

    def default
      new do |a|
        a.accounting = 0
        a.bs_user = 1
        a.cs_sheet = 1
        a.lesson_report = 0
        a.parent = 0
        a.tutor = 1
        a.student = 1
        a.hq_user = 1
      end
    end

    def keys
      @keys ||= [:hq_user, :tutor, :student, :bs, :bs_user, :parent,
                 :accounting, :cs_sheet, :lesson_report,
                 :lesson, :exam, :message, :document_camera, :textbook,
                 :system_settings, :bs_app_form, :tutor_app_form, :meeting,
                 :bank]
    end
  end

  attr_accessible :accounting, :bs, :bs_user, :cs_sheet, :hq_user, :lesson_report,
                  :parent, :tutor, :student,
                  :lesson, :exam, :message, :document_camera, :textbook,
                  :system_settings, :bs_app_form, :tutor_app_form,
                  :meeting, :bank
  belongs_to :user

  validates_each keys do |record, attr, value|
    record.errors.add attr, "invalid value" unless (0..2).include?(value)
  end

  validates_presence_of :user

  def allow_access?(resource, access_type)
    if resource.nil?
      true
    elsif respond_to?(resource)
      send(resource) >= level_of_access_type(access_type)
    else
      true
    end
  end

  def level_of_access_type(access_type)
    case access_type
    when :read
      1
    when :readwrite, :write
      2
    else
      100
    end
  end
end
