# coding: utf-8

class BsUser < User
  has_one :bs_app_form
  has_many :student_coaches, :foreign_key => :coach_id

  validates_presence_of :email
  validates_presence_of :first_name, :last_name, :organization_id,
                        :first_name_kana, :last_name_kana,
                        :sex
  validates_presence_of :birth_place, :if => :bs_owner?

  # scopeの指定はBSオーナーと教育コーチを分けるために入れてある。
  validates_uniqueness_of :nickname, scope: :type, allow_blank: true, message: :taken

  before_create do
    self.status = 'active'
  end

  after_create :on_registered

  def bs_owner?
    self.class == BsUser
  end

  def coach_of?(user)
    user.student? && user.organizatio_id == organization_id
  end

  def root_path
    bs_root_path
  end

  def tutors
    Tutor.scoped()
  end

  def special_tutors
    SpecialTutor.scoped
  end

  def students
    Student.where(organization_id:organization_id)
  end

  def bs_students
    Student.where(organization_id:organization_id)
  end

  def students_for_lesson(lesson)
    # BSオーナーの場合はレッスンの種類に関係なくBS所属の受講者全体を返す
    Student.where(organization_id:organization_id)
  end

  def bs_users
    BsUser.where(organization_id:organization_id)
  end

  def parents
    Parent.joins(:students).where(students_users:{organization_id:organization_id}).uniq
  end

  def coaches
    organization.coaches
  end

  # コーチに受講者をひもづける。
  # 受講者にすでにコーチが割り当てられている場合はそれを解除する。
  def assign_student(student)
    logger.debug 'Coarch#assign_student'
    BsUser.transaction do
      current_coach = student.reload.student_coach
      if current_coach.present?
        logger.info "Student #{student.id}'s coach is being changed from coach #{current_coach.coach_id}"
        current_coach.destroy
      end
      student_coaches.create(student: student)
      logger.info "Student #{student.id}'s coach is now coach #{id}"
    end
  end

  def search_parents(key, options={})
    search = Parent.search do
      [:active, :locked, :left].each do |filter|
        with filter, options[filter] if options.has_key?(filter)
      end
      with :organization_ids, [organization_id]
      if options[:page]
        paginate :page => options[:page], :per_page => 25
      end
      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end

  def lessons
    Lesson.includes(:students).where(users: {organization_id: organization_id}).uniq
  end


  def optional_lessons
    OptionalLesson.joins(:tutor).where(:users => {:organization_id => organization_id})
  end

  # Return CS sheets of students who belong to the same BS with this person
  def cs_sheets
    CsSheet.where(author_id: students.pluck(:id))
  end

  def lesson_reports
    LessonReport.where(student_id: students.pluck(:id))
  end

  def basic_lesson_infos
    BasicLessonInfo.includes(:students).where(users:{organization_id:organization_id}).uniq
  end

  def my_basic_lesson?(basic_lesson_info)
    basic_lesson_infos.where(id: basic_lesson_info.id).present?
  end

  # @param [Hash] params
  # @return [Interview]
  def arrange_interview(params)
    interview = Interview.new(start_time:params[:at]) do |interview|
      interview.creator = self
      interview.user1 = self
      interview.user2 = params[:with]
      interview.duration = 30
    end
    interview.save!
    interview
  end

  def contact_list
    # すべてのチューターと自分の管理する生徒とその保護者
    parent_ids = parents.select('users.id').map(&:id)
    User.where("(type = 'Tutor') OR (type = 'Student' AND organization_id = :organization_id) OR (type='Parent' AND id IN (:parent_ids))", organization_id:organization_id, parent_ids:parent_ids)
  end

  def contact_list=(user)
    # 追加はしない
  end

  def clear_incomplete_basic_lesson_infos
    basic_lesson_infos.incomplete.destroy_all
  end

  ################################################################
  # 権限
  ################################################################

  def can_cancel?(lesson)
    lesson.cancellable_by_bs_user?(self)
  end

  def can_cancel_optional_lesson?(lesson)
    stat = monthly_stats.find_or_create_by_year_and_month(lesson.start_time.year, lesson.start_time.month)
    stat.optional_lesson_cancellation_count < 3
  end

  ################################################################
  # 設定値
  ################################################################

  def basic_lesson_cancellation_limit_per_month
    1
  end

  private

    def on_registered
      # BSアカウントと本部にメールを送る
      Mailer.send_mail(:bs_user_registered, self, password)
    end

    def create_mail(mail_type, *args)
      BsUserMailer.send mail_type, self, *args
    end

end
