# coding:utf-8

#
# 受講者のID管理費を正しく課金できているかチェックする
#

class Date
  def year_month
    "#{year}/#{month}"
  end
end


start_month = Date.new(2013, 2)
current_month = Date.today.beginning_of_month.to_date

def should_be_charged(enrolled_month, payment_month)
  enrolled_month < payment_month
end

class MonthGenerator
  def initialize(from, to)
    @from = from
    @to = to
    @current = nil
  end

  def next
    if @current.nil?
      @current = @from
    elsif @current < @to
      @current = @current.next_month
    else
      nil
    end
  end
end

enrolled_months = MonthGenerator.new(start_month, current_month)
while enrolled_month = enrolled_months.next
  payment_months = MonthGenerator.new(start_month, current_month)
  while payment_month = payment_months.next
    if enrolled_month <= payment_month
      students = Student.enrolled_in(enrolled_month.year, enrolled_month.month).only_active
      if should_be_charged(enrolled_month, payment_month)
        print "#{enrolled_month.year_month} 入会の受講者は #{payment_month.year_month} のID管理費を支払います"
        if students.any?{|s| s.id_management_fees.of_month(payment_month.year, payment_month.month).empty?}
          puts ' ...fail'
        else
          puts ' ...OK'
        end
      else
        print "#{enrolled_month.year_month} 入会の受講者は #{payment_month.year_month} のID管理費を支払いません"
        if students.any?{|s| s.id_management_fees.of_month(payment_month.year, payment_month.month).present?}
          puts ' ...fail'
        else
          puts ' ...OK'
        end
      end
    end
  end
  puts
end
