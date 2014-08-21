class NotifyMonthlyPaymentFixed < ScheduledJob
  include Loggable

  def self.perform
    notify_to_parents
    notify_to_students
  end

  private

  def self.notify_to_parents
    Parent.only_active.find_each do |parent|
      notify_to_parent parent
    end
  end

  def self.notify_to_parent(parent)
    today = Date.today
    monthly_statement = parent.monthly_statements.of_month(today.year, today.month).first
    unless parent.free?
      if monthly_statement.present?
        parent.send_mail :monthly_payment_fixed, monthly_statement
      end
    end
    true
  rescue => e
    logger.error e
    false
  end

  def self.notify_to_students
    Student.only_active.only_independent.find_each do |student|
      notify_to_student student
    end
  end

  def self.notify_to_student(student)
    today = Date.today
    monthly_statement = student.monthly_statements.of_month(today.year, today.month).first
    unless student.free?
      if monthly_statement.present?
        student.send_mail :monthly_payment_fixed, monthly_statement
      end
    end
    true
  rescue => e
    logger.error e
    false
  end
end
