# coding:utf-8

class BsMonthlyResult < ActiveRecord::Base
  class << self
    def of_month(year, month)
      where(year:year, month:month).first
    end

    def of_year(year)
      where(year:year).order(:month)
    end
  end

  belongs_to :organization
  attr_accessible :lesson_sales_amount

  validates_presence_of :year, :month

  def calculate
    self.lesson_sales_amount = calculate_lesson_sales_amount
    self.lesson_sales_of_regular_tutors = calculate_lesson_sales_of_regular_tutors
    self.bs_share_of_lesson_sales = (lesson_sales_of_regular_tutors * SystemSettings.bs_share_of_lesson_sales).to_i
    self.calculated = true
    save
    self
  end

  def optional_lesson_fees
    organization.optional_lesson_fees.of_month(year, month)
  end

  def basic_lesson_fees
    organization.basic_lesson_fees.of_month(year, month)
  end

  def calculate_lesson_sales_amount
    optional_lesson_fee = optional_lesson_fees.sum(:amount_of_payment)
    basic_lesson_fee = basic_lesson_fees.sum(:amount_of_payment)
    optional_lesson_fee + basic_lesson_fee
  end

  def calculate_lesson_sales_of_regular_tutors
    optional_lesson_fee = optional_lesson_fees.only_includes_bs_share.sum(:amount_of_payment)
    basic_lesson_fee = basic_lesson_fees.only_includes_bs_share.sum(:amount_of_payment)
    optional_lesson_fee + basic_lesson_fee
  end

  # 仕訳データから各種値を集計する
  def update_with_journal_entries
    self.lesson_sales_amount = organization.calculate_lesson_sales_of_month(year, month)
    save
  end

  def date
    Date.new(year, month)
  end

  # 集計結果にもとづく取引の実施およびそれに派生する仕訳データの作成をおこなう
  # calculateの計算はここで作成される仕訳データには依存しないこと
  # 月別の結果を更新するのではなく、月別結果から派生する仕訳を更新するということに注意
  def update_deals
    transaction do
      update_lesson_sale_amount
    end
  end

  def update_journals!
    # 既存のものを削除してから作成し直す
    organization.journals.of_month(year, month).of_type(Account::LessonSaleAmount).destroy_all
    organization.journal_entries << Account::LessonSaleAmount.create! do |entry|
      entry.year = year
      entry.month = month
      entry.amount_of_money_received = bs_portion_of_lesson_sales_amount
    end
  end

  def bs_portion_of_lesson_sales_amount
    lesson_sales_amount * SystemSettings.bs_share_of_lesson_sales
  end

  private

  # 売上げデータに基づく仕訳データを作成・更新する。
  def update_lesson_sale_amount
    if organization.is_a?(Bs)
      deals = Account::LessonSaleAmount.of_month(year, month).where(payee_id:organization.id)
      logger.info("#{deals.count} LESSON SALES AMOUNT DEALS ARE BEING DELETED")
      deals.destroy_all
      Account::LessonSaleAmount.create!(payee:organization,
                                        year:year,
                                        month:month)
    end
    true
  rescue => e
    logger.error e
    false
  end
end
