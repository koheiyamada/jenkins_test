year = Date.today.year

(1...Date.today.month).each do |month|
  puts "YEAR: #{year}, MONTH: #{month}"

  if ARGV.size > 1
    YuchoBilling.of_month(year, month).each do |b|
      b.destroy
    end
    HqYuchoPayment.of_month(year, month).each do |b|
      b.destroy
    end
  end

  billing = YuchoBillingService.new
  ActiveRecord::Base.transaction do
    billing.make_billings_for_month(year, month)
    billing.print_billings_for_month(year, month)
  end

  payment = YuchoPaymentService.new
  ActiveRecord::Base.transaction do
    payment.make_payments_for_month(year, month)
    payment.print_payments_for_month(year, month)
  end
end

