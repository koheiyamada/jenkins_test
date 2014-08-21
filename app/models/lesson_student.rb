# -*- encoding: utf-8 -*- #
class LessonStudent < ActiveRecord::Base

  class Status
    ACTIVE      = 'active'
    CANCELLED   = 'cancelled'
    DROPPED_OUT = 'dropped_out'
  end

  class << self
    def of_student(student)
      find_by_student_id student.id
    end
  end

  scope :remaining, where(status: Status::ACTIVE)
  scope :active, where(status: Status::ACTIVE)
  scope :attended, where('attended_at IS NOT NULL')

  belongs_to :lesson
  belongs_to :student
  has_one :lesson_extension_request, :dependent => :destroy
  has_one :lesson_cancellation, :dependent => :destroy
  has_one :lesson_dropout, :dependent => :destroy
  has_one :lesson_charge

  validates_presence_of :lesson
  validate :left_at_cannot_be_changed
  validates_inclusion_of :status, :in => %w(active cancelled dropped_out)
  validate :lesson_dropout_present?, if: 'status_changed? && dropped_out?'
  validates_uniqueness_of :student_id, scope: :lesson_id

  before_create :init_base_lesson_fee_per_unit
  after_create :update_lesson_search_index
  after_update :notify_dropped_out, if: :become_dropped_out?
  after_destroy :update_lesson_search_index

  def active?
    status == Status::ACTIVE
  end

  def attend!
    if attended_at.blank?
      update_attribute(:attended_at, Time.now)
      logger.lesson_log("STUDENT_ATTENDED", lesson_id:lesson_id, student_id:student.id, student_user_name:student.user_name)
    else
      logger.lesson_log("STUDENT_ATTENDED_AGAIN", lesson_id:lesson.id, student_id:student.id, student_user_name:student.user_name)
    end
  end

  def attended?
    attended_at.present?
  end

  def enter
    if entered_at.blank?
      touch(:entered_at)
      logger.lesson_log('STUDENT_ENTERED', lesson_id:lesson.id, student_id:student.id, student_user_name:student.user_name)
    else
      logger.lesson_log('STUDENT_ENTERED_AGAIN', lesson_id:lesson.id, student_id:student.id, student_user_name:student.user_name)
    end
  end

  def entered?
    entered_at.present?
  end

  # 参加中のレッスンから引き上げる
  def drop_out
    lesson_dropout || create_lesson_dropout
  end

  def on_dropped_out(dropout)
    self.status = 'dropped_out'
    self.left_at = dropout.created_at
    if save
      logger.lesson_log('STUDENT_DROPPED_OUT', lesson_id: id, student_id: student.id, student_user_name: student.user_name)
    end
    self
  end

  def dropped_out?
    lesson_dropout.present?
  end

  def leave
    self.left_at = Time.now
    self.status = Status::DROPPED_OUT
    save
    self
  end

  def left?
    left_at.present?
  end

  # 受講者がこのレッスンへの参加を取りやめる
  # レッスン自体のキャンセルとは別
  def cancel(options = {})
    transaction do
      lesson_cancellation || create_lesson_cancellation(options)
    end
  end

  def cancelled?
    status == Status::CANCELLED
    #lesson_cancellation.present?
  end

  # lesson_cancellationが作成されると呼び出される
  def on_cancelled
    self.status = Status::CANCELLED
    self.cancelled_at = Time.now
    save
    if valid?
      lesson.on_student_cancelled(self)
      student.on_lesson_cancelled(lesson)
    else
      logger.lesson_log 'FAILED'
    end
  end

  def charge
    lesson_charge || create_lesson_charge
  end

  def charge!
    lesson_charge || create_lesson_charge!
  end

  # レッスンが同時レッスン割引
  def group_lesson_discount?
    lesson.group_lesson_discount_applicable?
  end

  def group_lesson_discount_applied?
    lesson.group_lesson_discount_applicable?
  end

  ## オリジナルのレッスン受講料を格納。無料レッスンなら回数も格納
  def journalize(lesson_charge)
    if lesson_fee_entry.present?
      lesson_fee_entry
    elsif lesson.free?
      student.journalized_free_lesson_count += 1
      student.save
      note = "無料受講レッスン（#{student.journalized_free_lesson_count}回目）"
      note2 = "無料受講レッスンのため、#{original_lesson_fee}円のレッスン料を無償とさせていただきます。"
      lesson.lesson_fees.create(owner: student, amount_of_payment: lesson_charge.fee, includes_bs_share: lesson.has_bs_share?, original_lesson_fee: original_lesson_fee, note: note, note2: note2)
    else
      lesson.lesson_fees.create(owner: student, amount_of_payment: lesson_charge.fee, includes_bs_share: lesson.has_bs_share?)
    end
  end

  def lesson_fee_entry
    student.lesson_fees.find_by_lesson_id(lesson.id)
  end

  # 割引、延長を含んだ金額
  def lesson_fee
    @lesson_fee ||= calculate_lesson_fee
  end

  def on_lesson_fixed
    update_base_lesson_fee_per_unit
  end

  # この受講者のレッスン料のベースとなる額を更新する
  def update_base_lesson_fee_per_unit
    init_base_lesson_fee_per_unit
    save
  end

  def base_lesson_fee
    @base_lesson_fee ||= base_lesson_fee_per_unit * lesson.units
  end

  def extension_fee_amount
    Lesson.extension_fee(base_lesson_fee_per_unit)
  end

  def group_lesson_discount_amount
    Lesson.group_lesson_discount(base_lesson_fee + extension_fee)
  end

  private

    def calculate_lesson_fee
      logger.debug "base_fee=#{base_lesson_fee}, extension_fee=#{extension_fee}, discount=#{group_lesson_discount}"
      amount = base_lesson_fee + extension_fee - group_lesson_discount
      lesson.free? ? 0 : amount
    end

    ## 無料レッスン時、オリジナルのレッスン料を取得するために使用
    def original_lesson_fee
      base_lesson_fee + extension_fee - group_lesson_discount
    end

    def extension_fee
      @extension_fee ||= lesson.extended? ? Lesson.extension_fee(base_lesson_fee_per_unit) : 0
    end

    def group_lesson_discount
      @group_lesson_discount ||= group_lesson_discount? ? group_lesson_discount_amount : 0
    end

    def left_at_cannot_be_changed
      if left_at_changed? && !left_at_was.nil?
        errors.add(:left_at, :duplicate_change)
      end
    end

    def lesson_dropout_present?
      errors.add :status, :cannot_be_dropped_out unless lesson_dropout.present?
    end

    def notify_dropped_out
      lesson.on_student_dropped_out self
    end

    def become_dropped_out?
      status_changed? && dropped_out?
    end

    def update_lesson_search_index
      lesson.update_index_async
    end

    def init_base_lesson_fee_per_unit
      return false if lesson.blank? || student.blank?
      if base_lesson_fee_per_unit.blank? && lesson.tutor.present?
        self.base_lesson_fee_per_unit = lesson.tutor.lesson_fee_for_student(student)
      end
      logger.debug "base_lesson_fee_per_unit = #{base_lesson_fee_per_unit}"
      true
    end
end
