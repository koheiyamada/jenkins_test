Parent.all.each do |parent|
  if parent.payment_method.blank?
    parent.payment_method = CreditCardPayment.new
    puts "Parent #{parent.id}'s payment method becomes credit card"
  else
    puts "Parent #{parent.id}'s payment method is #{parent.payment_method.class.name}."
  end
end