# coding:utf-8

#
# 保護者や受講者などに請求をする
#
class YuchoBillingService
  include Loggable

  def make_billings_for_month(year, month)
    mss = MonthlyStatement.of_month(year, month).where('amount_of_payment > 0')
    mss.each do |ms|
      if ms.yucho_payment?
        if should_make_billing?(ms)
          monthly_statement_to_yucho_billing(ms)
        end
      end
    end
  end

  def clear_billings_for_month(year, month)
    YuchoBilling.of_month(year, month).destroy_all
  end

  def print_billings_for_month(year, month, out_file)
    file = Tempfile.new('yucho_payment_writer', :encoding => Encoding::CP932)
    file.puts I18n.t('yucho_payment_writer.heading')
    YuchoBilling.of_month(year, month).each do |yucho_billing|
      if yucho_billing.amount != 0
        print_yucho_billing(yucho_billing, file)
      end
    end
  ensure
    file.close
    FileUtils.cp file.path, out_file
    FileUtils.chmod 'g+r', out_file
    file.unlink
  end

  def print_yucho_billing(yucho_billing, file)
    ya = yucho_billing.yucho_account
    user = ya.owner
    line = "#{ya.kigo1},#{ya.bango},#{ya.account_holder_name_kana},#{yucho_billing.amount},#{user.user_name},1"
    file.puts line.encode('CP932')
  end

  def monthly_statement_to_yucho_billing(monthly_statement)
    owner = monthly_statement.owner
    account = owner.bank_account.account
    billing = YuchoBilling.new do |b|
      b.yucho_account = account
      b.monthly_statement = monthly_statement
      b.amount  = monthly_statement.amount_of_payment
    end
    if billing.save
      logger.info "Yucho Billing: year:#{monthly_statement.year}, month:#{monthly_statement.month}, amount:#{billing.amount}, #{owner.attributes}"
    else
      logger.error "Yucho Billing Failed:#{billing.errors.full_messages}"
    end
    billing
  end

  # 保護者と受講者は常に請求の対象となる。
  # それ以外は支払額がある場合のみ。
  def should_make_billing?(monthly_statement)
    owner = monthly_statement.owner
    if owner.is_a?(Student) || owner.is_a?(Parent)
      true
    else
      # monthly_statementは支払相手のものなので、
      # 参照する金額は相手にとっての支払額
      monthly_statement.amount_of_payment > 0
    end
  end
end