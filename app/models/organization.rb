class Organization < ActiveRecord::Base
  class << self
    def of_type(type)
      where(type:type)
    end
  end

  has_many :users
  has_many :parents
  has_many :students
  belongs_to :address, :autosave => true
  has_many :journal_entries, class_name:Account::JournalEntry, :as => :owner
  has_many :monthly_statements, :as => :owner
  has_many :monthly_results, class_name:BsMonthlyResult.name
  belongs_to :representative, class_name:User.name, :validate => true

  # 会計科目
  has_many :optional_lesson_fees, class_name:Account::OptionalLessonFee.name
  has_many :basic_lesson_fees, class_name:Account::BasicLessonFee.name
  has_many :group_lesson_discounts, class_name:Account::GroupLessonDiscount.name

  has_many :lesson_charges

  attr_accessible :name, :type, :email, :phone_number, :address, :representative_id

  scope :only_active, where(active:true)

  def bs?
    is_a?(Bs)
  end

  def headquarter?
    is_a?(Headquarter)
  end

  def lessons
    Lesson.joins(:students).where(users: {organization_id: id}).uniq
  end

  def bs_users
    users.where(type:"BsUser")
  end

  def contactable_members
    users.limit(1)
  end

  # この組織のうちメッセージが届く
  def message_recipients
    []
  end

  def emails
    message_recipients.flat_map(&:emails).compact.uniq
  end

  # 指定した月の集計データを返す。
  def result_of_month(year, month)
    monthly_results.of_month(year, month)
  end

  # 指定した月の集計データを計算して返す。
  # 結果は月別成績テーブルに保存される。
  # 指定した月のデータがまだ存在しない場合は新しく作成して集計した結果を返す。
  # データが既存の場合も最新の状態に更新したものを返す
  # @return 計算された月別成績データ
  def update_monthly_result!(year, month)
    monthly_result = monthly_results.find_or_create_by_year_and_month(year, month)
    monthly_result.calculate
    monthly_result
  end

  def create_monthly_statement_update_request(year, month)
    req = MonthlyStatementUpdateRequest.new(owner: self, year: year, month: month)
    req.save
    req
  end

  def lesson_sales_of_month(year, month)
    monthly_result = update_monthly_result!(year, month)
    monthly_result.lesson_sales_amount
  end

  # 月のレッスン売上をデータベースにあるデータから計算して返す。
  # @return レッスン売上合計
  def calculate_lesson_sales_of_month(year, month)
    optional_lesson_fee = optional_lesson_fees.of_month(year, month).sum(:amount_of_payment)
    basic_lesson_fee = basic_lesson_fees.of_month(year, month).sum(:amount_of_payment)
    group_lesson_discount = group_lesson_discounts.of_month(year, month).sum(:amount_of_money_received)
    optional_lesson_fee + basic_lesson_fee - group_lesson_discount
  end

  ################################################################
  # 会計
  ################################################################

  # 毎月発生する科目データを作成する
  def update_monthly_journal_entries!(year, month)
    # 実際の処理はサブクラスで
  end

  # 月次集計を作成・更新する
  def update_monthly_statement_for(year, month)
    monthly_statement = monthly_statements.find_or_create_by_year_and_month(year, month)
    monthly_statement.calculate
    monthly_statement
  end
end
