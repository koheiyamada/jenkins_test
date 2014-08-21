# coding:utf-8

class MonthlyStatementCalculation < ActiveRecord::Base
  class << self
    def execute(year, month)
      obj = new(year: year, month: month)
      if obj.save
        obj.execute
      end
      obj
    end
  end

  attr_accessible :month, :status, :year

  validates_presence_of :year, :month
  validates_inclusion_of :status, in: %w(new success error)

  def new?
    status == 'new'
  end

  def success?
    status == 'success'
  end

  def error?
    status == 'error'
  end

  def execute
    logger.info('MonthlyStatementCalculation.execute is called')
    transaction do
      Lesson.journalize_for_month!(year, month)
      calculate_for_students(year, month)
      calculate_for_tutors(year, month)
      calculate_for_bss(year, month)
      calculate_for_headquarter(year, month)
      YuchoAccountService.new.compile_billings_and_payments_files(year, month)
      self.update_attribute :status, 'success'
    end
    logger.charge_log('MONTHLY_STATEMENT_CALCULATED')
    self
  rescue => e
    Rails.logger.error e
    Rails.logger.error e.backtrace if e.backtrace.present?
    self.update_attribute :status, 'error'
    SystemAdminMailer.error_on_charging('MonthlyStatementCalculation#execute', e).deliver
  end

  private

    def calculate_for_students(year, month)
      Student.only_active.each do |student|
        student.update_monthly_statement_for(year, month)
      end
    end

    # 全チューターの月次集計を実行する
    def calculate_for_tutors(year, month)
      Tutor.only_active.each do |tutor|
        tutor.update_monthly_statement_for(year, month)
      end
    end

    # 全BSの月次集計を実行する
    def calculate_for_bss(year, month)
      Bs.only_active.each do |bs|
        bs.update_monthly_statement_for(year, month)
      end
    end

    # 本部の月次集計を実行する
    def calculate_for_headquarter(year, month)
      Headquarter.only_active.each do |headquarter|
        headquarter.update_monthly_statement_for(year, month)
      end
    end
end
