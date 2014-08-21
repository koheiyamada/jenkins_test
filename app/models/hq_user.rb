# encoding: utf-8
class HqUser < User

  validates_uniqueness_of :nickname, allow_blank: true, message: :taken

  before_validation do
    if access_authority.blank?
      self.access_authority = AccessAuthority.default
    end
    if organization_id.blank?
      self.organization = Headquarter.instance
    end
  end

  before_create do
    self.status = 'active'
  end

  def root_path
    hq_root_path
  end

  def contact_list
    User.only_active.order("type")
  end

  def students
    Student.where('users.type != ?', TrialStudent.name)
  end

  def trial_students
    TrialStudent.scoped
  end

  def tutors
    Tutor.scoped()
  end

  def special_tutors
    #SpecialTutor.scoped
    Tutor.where(type: 'SpecialTutor')
  end

  def bs_users
    BsUser.scoped()
  end

  def parents
    Parent.scoped()
  end

  def basic_lesson_infos
    BasicLessonInfo.scoped
  end

  def lessons
    Lesson.scoped()
  end

  def lesson_reports
    LessonReport.scoped
  end

  def cs_sheets
    CsSheet.scoped
  end

  def bss
    Bs.scoped()
  end

  def search_students(key, options={}, conditions)
    search = Student.search do
      [:active, :locked, :left].each do |filter|
        with filter, options[filter] if options.has_key?(filter)
      end
      if conditions['grade'].present?
        user_ids = User.new.searching_users_by_grade(conditions['grade'])
        user_ids = 0 if user_ids.blank?
        with :student_id, user_ids
      end
      if conditions['customer_type'] == 'free'
        with :customer_type,  'free'
      end
      if conditions['customer_type'] == 'premium'
        with :customer_type,  "premium"
      end
      if conditions['customer_type'] == 'request_to_premium'
        with :customer_type,  "request_to_premium"
      end
      if options[:organization_id]
        with :organization_id, options[:organization_id]
      end
      if options[:page]
        paginate :page => options[:page], :per_page => 25
      end
      if options[:exclude_trial]
        without :trial, true
      end
      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end

  def search_parents(key, options={})
    search = Parent.search do
      [:active, :locked, :left].each do |filter|
        with filter, options[filter] if options.has_key?(filter)
      end
      if options[:conditions]
        if options[:conditions][:customer_type] == 'free'
          with :customer_type, ['free','request_to_premium','premium']
        elsif options[:conditions][:customer_type] == 'premium'
          with :customer_type, ['premium','request_to_premium','free']
        elsif options[:conditions][:customer_type] == 'request_to_premium'
          with :customer_type,  ['request_to_premium','premium']
        end
      end
      if options[:page]
        paginate :page => options[:page], :per_page => 25
      end
      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end

  def clear_incomplete_basic_lesson_infos
    BasicLessonInfo.created_by(self).incomplete.destroy_all
  end

  ################################################################
  # 権限
  ################################################################

  def can_cancel?(lesson)
    lesson.cancellable_by_hq_user?(self)
  end

  def can_access?(resource, access_type)
    admin? || (access_authority && access_authority.allow_access?(resource, access_type))
  end

  private

    def create_mail(mail_type, *args)
      HqUserMailer.send mail_type, self, *args
    end

end
