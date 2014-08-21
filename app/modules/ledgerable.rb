# 帳簿機能を追加するモジュール
module Ledgerable

  def self.included(base)
    base.has_many :journal_entries_as_payee, class_name:Account::JournalEntry, :as => :payee
    base.has_many :journal_entries_as_payer, class_name:Account::JournalEntry, :as => :payer
    class_name = base.name + "Ledger"
    base.has_many :ledgers, class_name:class_name, :as => :ledgerable
    base.extend ClassMethods
  end

  def self.classes
    [Student, Tutor, Bs, Soba, TextbookCompany]
  end

  module ClassMethods
    def make_ledgers_of_month(month)
      self.only_active.each do |user|
        user.make_ledger_of_month(month)
      end
    end
  end


  #def journal_entries
  #  Account::JournalEntry.where("(payer_id=:id AND payer_type=:type) OR (payee_id=:id AND payee_type=:type)", id:id, type:self.class.name)
  #end

  # 引数で指定した月の帳簿データを返す。
  # その月の帳簿データがない場合は作成する。
  def ledger_of_month(year, month)
    day = Date.new(year.to_i, month.to_i)
    ledgers.find_or_create_by_month(day)
  end

  def make_ledger_of_month(month)
    month = normalize_month(month)
    ledger = ledger_of_month(month.year, month.month)
    unless ledger.closed?
      ledger.calculate!
    end
    ledger.reload
  end

  def latest_ledgers
    ledgers.order("month DESC")
  end

  private

  def normalize_month(month)
    month.beginning_of_month.to_date
  end

end