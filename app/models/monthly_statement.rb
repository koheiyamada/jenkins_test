class MonthlyStatement < ActiveRecord::Base

  class << self
    def of_year(year)
      where(year:year)
    end

    def of_month(year, month)
      where(year: year, month: month)
    end

    def settle(year = Date.today.year, month = Date.today.month)
      calculate_for_all_and_charge_the_payment_of_all_students(year, month)
      YuchoAccountService.new.compile_billings_and_payments_files(year, month)
    end

    # 生徒、チューター、BS、本部の月次集計を実行する
    def calculate_for_all(year, month)
      calc = MonthlyStatementCalculation.execute(year, month)
      if calc.errors.any?
        logger.error "Failed to calculate a new monthly statement for #{year}/#{month}, #{calc.errors.full_messages}"
      end
    end

    # 生徒、チューター、BS、本部の月次集計を実行し、
    # 全生徒の支払い料金を課金する
    def calculate_for_all_and_charge_the_payment_of_all_students(year, month)
      calculate_for_all(year, month)
      charge_the_payment_of_all_students(year, month)
    end

    # 全生徒の料金支払いを実行する
    def charge_the_payment_of_all_students(year, month)
      charge_the_payment_of_all_dependent_students(year, month)
      charge_the_payment_of_all_independent_students(year, month)
    end

    # 親の**いる**全生徒の料金支払いを実行する
    # 多重課金防止の為、monthly_statement#paid が false のものだけに課金の実行を行い、
    # 支払いが完了した生徒の monthly_statement#paid は true に設定する
    def charge_the_payment_of_all_dependent_students(year, month)
      Parent.only_active.find_each do |parent|
        student_ids = parent.students.only_active.pluck(:id)
        monthly_statements = where(owner_id:student_ids, year:year,
                                   month:month, paid:false)
        amount = monthly_statements.sum(:amount_of_payment) - monthly_statements.sum(:amount_of_money_received)
        unless amount.zero?
          begin
            parent.payment(amount)
          rescue => e
            logger.error e
          else
            monthly_statements.update_all(paid:true)
          end
        end
      end
    end

    # 親の**いない**全生徒の料金支払いを実行する
    # 多重課金防止の為、monthly_statement#paid が false のものだけに課金の実行を行い、
    # 支払いが完了した生徒の monthly_statement#paid は true に設定する
    def charge_the_payment_of_all_independent_students(year, month)
      Student.only_active.find_each do |student|
        next unless student.independent?
        monthly_statement = student.monthly_statements.of_month(year, month).unpaid.first
        amount = monthly_statement.blank? ? 0 : (monthly_statement.amount_of_payment - monthly_statement.amount_of_money_received)
        if amount > 0
          begin
            student.payment(amount)
          rescue => e
            logger.error e
          else
            monthly_statement.update_attribute(:paid, true)
          end
        end
      end
    end

    def unpaid
      where(paid: false)
    end
  end

  belongs_to :owner, :polymorphic => true
  has_many :items, class_name:MonthlyStatementItem.name

  attr_accessible :amount_of_money_received, :amount_of_payment, :month, :year, :owner,
                  :tax_of_money_received, :tax_of_payment

  validates_presence_of :owner, :month, :year

  # year, monthの月の、ownerの項目別集計を計算する
  # すでにデータが有る場合は削除してから計算し直す。
  def calculate
    transaction do
      clear_items

      # ownerのタイプごとに発生する毎月の仕訳を計算する
      # BSのレッスン料の取り分もここで計算する
      owner.update_monthly_journal_entries!(year, month)

      # 計算を実行する
      calculate_from_journal_entries

      if changed?
        logger.info "Monthly statement of #{owner} for #{year}/#{month} updated"
        save
      else
        logger.info "Monthly statement of #{owner} for #{year}/#{month} not updated"
        touch
      end
      self
    end
  end

  def journal_entries
    owner.journal_entries.of_month(year, month)
  end

  def date
    Date.new(year, month)
  end

  def clear_items
    self.amount_of_money_received = 0
    self.amount_of_payment = 0
    items.destroy_all
  end

  def adjusting_entries
    owner.journal_entries.of_type(Account::AdjustingEntry).of_month(year, month)
  end

  def yucho_payment?
    if owner.is_a? BankAccountOwner
      bank_account = owner.bank_account
      if bank_account.present?
        bank_account.yucho?
      else
        false
      end
    else
      false
    end
  end

  def yucho_receipts?

  end

  def yucho_account
    if owner.is_a? Student
      if owner.independent?
        owner.bank_account.account
      else
        parent = owner.parent
        parent.bank_account.account
      end
    elsif owner.is_a? BankAccountOwner
      owner.yucho_account
    end
  end

  def payment_tax
    tax_of_payment - tax_of_money_received
  end

  def receipt_tax
    -payment_tax
  end

  def receipt
    amount_of_money_received - amount_of_payment + receipt_tax
  end

  private

    # 仕訳の項目ごとの累計額を計算する。
    def calculate_from_journal_entries
      grouped_entries = journal_entries.group_by(&:type)

      sum_of_payment = 0
      sum_of_money_received = 0
      grouped_entries.each do |type, entries|
        item = items.create! do |obj|
          obj.account_item = type
          obj.year = year
          obj.month = month
          if owner.is_a?(Headquarter)
            # 本部の集計では支払と受取の項目を入れ替える。
            # 受講者の支払は本部の受取となる。
            obj.amount_of_payment = entries.sum(&:amount_of_money_received)
            obj.amount_of_money_received = entries.sum(&:amount_of_payment)
          else
            obj.amount_of_payment = entries.sum(&:amount_of_payment)
            obj.amount_of_money_received = entries.sum(&:amount_of_money_received)
          end
        end
        sum_of_payment += item.amount_of_payment
        sum_of_money_received += item.amount_of_money_received
      end

      # 税金
      if should_add_tax?
        self.tax_of_payment = (sum_of_payment * SystemSettings.instance.tax_rate).to_i
        self.tax_of_money_received = (sum_of_money_received * SystemSettings.instance.tax_rate).to_i
      else
        self.tax_of_payment = 0
        self.tax_of_money_received = 0
      end
      # 合計金額
      self.amount_of_payment        = sum_of_payment + tax_of_payment
      self.amount_of_money_received = sum_of_money_received + tax_of_money_received
    end

    def update_journal_entries_with_monthly_result
      if owner.is_a?(Bs)
        result = owner.update_monthly_result!(year, month)
        result.update_deals
      end
    end

    def should_add_tax?
      owner.is_a?(Bs) || owner.is_a?(Student)
    end
end
