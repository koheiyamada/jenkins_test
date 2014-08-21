# coding:utf-8
require 'spec_helper'

describe PaymentMethod do
  let(:parent) {FactoryGirl.create(:parent)}

  it 'クレジットカード支払を選べる' do
    #m = parent.payment_method = CreditCardPayment.new #create_payment_method(type: CreditCardPayment.name)
    parent.payment_method = PaymentMethod.new(type: CreditCardPayment.name)
    parent.payment_method.should be_persisted
    PaymentMethod.find(parent.payment_method.id).should be_a(CreditCardPayment)
  end
end
