# coding:utf-8

# 本部がBSやチューターなどに支払いをする
# ここでのPaymentは本部から見た「支払」であることに注意
class YuchoPaymentService
  include Loggable

  def make_payments_for_month(year, month)
    mss = MonthlyStatement.of_month(year, month).where('amount_of_money_received > 0')
    mss.each do |ms|
      if ms.yucho_payment?
        if should_make_payment?(ms)
          monthly_statement_to_yucho_payment(ms)
        end
      end
    end
  end

  def clear_payments_for_month(year, month)
    HqYuchoPayment.of_month(year, month).destroy_all
  end

  def print_payments_for_month(year, month, out_file)
    file = Tempfile.new('hq_yucho_payments', :encoding => Encoding::CP932)
    file.puts I18n.t('hq_yucho_payment.heading')
    HqYuchoPayment.of_month(year, month).each do |yucho_payment|
      if yucho_payment.amount != 0
        print_yucho_payment(yucho_payment, file)
      end
    end
  ensure
    file.close
    FileUtils.cp file.path, out_file
    FileUtils.chmod 'g+r', out_file
    file.unlink
  end

  def print_yucho_payment(yucho_payment, file)
    ya = yucho_payment.yucho_account
    user = ya.owner
    line = "#{ya.kigo1},#{ya.bango},#{ya.account_holder_name_kana},#{yucho_payment.amount},#{user.user_name},1"
    file.puts line.encode('CP932')
  end

  def monthly_statement_to_yucho_payment(monthly_statement)
    owner = monthly_statement.owner
    account = owner.bank_account.account
    payment = HqYuchoPayment.new do |b|
      b.yucho_account = account
      b.monthly_statement = monthly_statement
      b.amount  = monthly_statement.amount_of_money_received # 本部の支払額は、相手の受取額
    end
    if payment.save
      logger.info "HqYuchoPayment: year:#{monthly_statement.year}, month:#{monthly_statement.month}, amount:#{payment.amount}, #{owner.attributes}"
    else
      logger.error "HqYuchoPayment Failed:#{payment.errors.full_messages}"
    end
    payment
  end

  # 保護者と受講者は常に支払の対象となる。
  # 本部の月次集計は対象とならない。
  # それ以外は支払額がある場合のみ。
  def should_make_payment?(monthly_statement)
    owner = monthly_statement.owner
    if owner.is_a?(Headquarter)
      false
    elsif owner.is_a?(Bs) || owner.is_a?(Tutor)
      true
    else
      # monthly_statementは支払相手のものなので、
      # 参照する金額は相手にとっての受取額
      monthly_statement.amount_of_money_received > 0
    end
  end
end