# coding: utf-8

class YuchoAccount < ActiveRecord::Base

  class << self
    # 保護者、受講者からのゆうちょ支払いデータを編纂する
    # すでにデータが有る場合は
    def compile_payments_file_of_month(year, month)
      YuchoAccountService.new.compile_billings_file_of_month(year, month)
    end

    # チューター、BSが受け取るデータを編纂する
    def compile_recipients_file_of_month(year, month)
      YuchoAccountService.new.compile_payments_file_of_month(year, month)
    end
  end

  has_one :bank_account, :as => :account
  attr_accessible :bango, :kigo1, :kigo2,
                  :account_holder_name, :account_holder_name_kana

  validates_presence_of :kigo1, :bango, :account_holder_name, :account_holder_name_kana

  validates_format_of :kigo2, with: /\A\d+\Z/, allow_blank: true
  validate :kigo1_is_valid
  validate :bango_is_valid

  before_validation :convert_to_hankaku
  before_save :pad_bango_with_zero

  def owner
    bank_account.owner
  end

  def monthly_statement_of_month(year, month)
    owner.monthly_statement_of_month(year, month)
  end

  private

    def kigo1_is_valid
      unless /\A\d{5}\Z/ =~ kigo1
        errors.add :kigo1, :must_be_five_digits
      end
    end

    def bango_is_valid
      unless /\A\d{6,8}\Z/ =~ bango
        errors.add :bango, :must_be_six_to_eight_digits
      end
    end

    def convert_to_hankaku
      self.kigo1 = kigo1.tr('０-９', '0-9') if kigo1.present?
      self.kigo2 = kigo2.tr('０-９', '0-9') if kigo2.present?
      self.bango = bango.tr('０-９', '0-9') if bango.present?
    end

    def pad_bango_with_zero
      if bango && bango.length < 8
        n = 8 - bango.length
        self.bango = '0' * n + bango
      end
    end
end
