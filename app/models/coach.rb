# coding:utf-8
class Coach < BsUser
  include Searchable

  class << self
    def max_count_for_bs
      SystemSettings.first.max_coach_count_for_area
    end

    def for_list
      includes(:organization)
    end
  end

  searchable auto_index: false do
    integer :coach_id, using: :id
    integer :organization_id
    boolean :active, using: :active?
    boolean :left, using: :left?
    text :user_name
    text :full_name
    text :full_name_kana
    text :nickname
    text :email
    text :area_name do
      organization.name
    end
    text :area_code do
      organization.area_code
    end
    string :sex
    time :created_at
    text :address do
      address && address.serialize
    end
    text :phone_number
  end

  has_many :student_coaches
  has_many :students, :through => :student_coaches, :uniq => true

  validates_presence_of :organization_id
  validates_format_of :user_name, with: /\A[@.a-zA-Z0-9_-]{1,100}\Z/
  validate :ensure_status_can_be_changed, if: :status_changed?
  validate :ensure_max_coaches_count_per_bs_is_satisfied, on: :create

  before_destroy :ensure_no_students_are_assigned
  before_create do
    self.status = 'active'
  end

  # コーチに受講者をひもづける。
  # 受講者にすでにコーチが割り当てられている場合はそれを解除する。
  def assign_student(student)
    logger.debug 'Coarch#assign_student'
    Coach.transaction do
      current_coach = student.reload.student_coach
      if current_coach.present?
        logger.info "Student #{student.id}'s coach is being changed from coach #{current_coach.coach_id}"
        current_coach.destroy
      end
      self.students << student
      logger.info "Student #{student.id}'s coach is now coach #{id}"
    end
  end

  def bs_students
    organization.students
  end

  def students_for_lesson(lesson)
    # 教育コーチはレッスンの種類によって対象となる受講者の範囲を変える
    if lesson.friends_lesson?
      bs_students
    else
      students
    end
  end

  def coach_of?(user)
    user.student? && student_ids.include?(user.id)
  end

  def parents
    parent_ids = students.pluck(:parent_id).uniq
    Parent.where(id: parent_ids)
  end

  def root_path
    bs_root_path
  end

  def lessons
    lesson_ids = LessonStudent.where(student_id: student_ids).pluck(:lesson_id)
    Lesson.where(id: lesson_ids)
  end

  def bs_owner
    organization.representative
  end

  def search_students(key, options={})
    if options.has_key? :lesson_style
      student_ids = resolve_student_search_target(options[:lesson_style])
      options[:student_id] = student_ids
    end
    super(key, options)
  end

  private

    def ensure_status_can_be_changed
      if status_was == 'active'
        # アクティブな状態から非アクティブな状態になることができるのは、
        # 受講者と関連付けられていない場合のみ。
        ensure_no_students_are_assigned
      end
    end

    def ensure_no_students_are_assigned
      if students.present?
        errors.add :students, :must_be_empty
        false
      end
    end

    def resolve_student_search_target(lesson_style)
      if lesson_style == :shared
        student_ids # 自分の受講者のみ
      elsif lesson_style == :friends
        bs_students.pluck(:id) # 所属BSの受講者全体
      else
        student_ids # 自分の受講者のみ
      end
    end

    def on_registered
      Mailer.send_mail(:coach_created, self, password)
    end

    def ensure_max_coaches_count_per_bs_is_satisfied
      if organization.present?
        if organization.coaches.count >= Coach.max_count_for_bs
          errors.add :organization_id, :is_full
        end
      end
    end
end
