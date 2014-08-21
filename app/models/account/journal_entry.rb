class Account::JournalEntry < ActiveRecord::Base

  class << self
    # 引数で与えた日にちに対応する決済月を返す
    def settlement_month_of_day(day)
      day.day > SystemSettings.cutoff_date ? day.next_month : day
    end

    def period_of_settlement_month(year, month)
      d = Date.new(year, month)
      from = d.prev_month.change(day:SystemSettings.cutoff_date + 1)
      to = d.change(day:SystemSettings.cutoff_date)
      from .. to
    end

    def for_list
      includes(:owner, :lesson)
    end

    ### サブクラス設定用

    # 支払人になれるユーザタイプを指定する
    def payer_type(*args)
      if args.empty?
        @payer_types ||= []
      else
        @payer_types = args
      end
    end

    # 高々月一回の支払とする
    def monthly_payment(*scope)
      @monthly_payment = true
      scope = [:year, :month] + scope
      validates_uniqueness_of :owner_id, :scope => scope, :if => :payer?
    end

    def amount_given
      @assign_amount_from_settings = true
    end

    attr_reader :assign_amount_from_settings

    def to_headquarter
      @to_headquarter = true
    end

    ##### クエリ

    def of_month(year, month)
      where(year:year, month:month)
    end

    def of_type(account_class)
      where(type:account_class.name)
    end
  end

  scope :only_includes_bs_share, where(includes_bs_share: true)

  belongs_to :referral, :class_name => User.name
  belongs_to :owner, :polymorphic => true
  belongs_to :client, :polymorphic => true
  belongs_to :lesson
  belongs_to :organization
  belongs_to :reversal_entry, class_name:Account::JournalEntry.name

  attr_accessible :amount, :settlement_date, :payer, :payee, :year, :month,
                  :amount_of_payment, :amount_of_money_received, :owner, :client, :lesson,
                  :note, :includes_bs_share

  validates_presence_of :year, :month, :owner
  validates_numericality_of :amount_of_payment
  validates_numericality_of :amount_of_money_received

  before_validation do
    if lesson
      self.year = lesson.settlement_year if year.blank?
      self.month = lesson.settlement_month if month.blank?
    end
    if owner.is_a?(Student)
      self.organization = owner.organization
    end
  end

  after_destroy do
    logger.journal_log 'DELETED', attributes
  end

  def year_month
    if year && month
      Date.new(year, month)
    end
  end

  def create_reversal_entry!
    if reversal_entry.blank?
      entry = dup
      entry.amount_of_payment = amount_of_money_received
      entry.amount_of_money_received = amount_of_payment
      # 返金処理の決済月は本日を含む決済月とする
      month = Account::JournalEntry.settlement_month_of_day(Date.today)
      entry.year = month.year
      entry.month = month.month

      entry.save!
      self.reversal_entry = entry
      save!
      entry
    else
      reversal_entry
    end
  end

  def reversed?
    reversal_entry.present?
  end

  def name
    self.class.model_name.human
  end

  private

    def payer?
      amount_of_payment && amount_of_payment > 0
    end

    def payee?
      amount_of_money_received && amount_of_money_received > 0
    end
end
