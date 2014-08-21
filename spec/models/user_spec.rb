# encoding: utf-8
require 'spec_helper'

describe User do
  disconnect_sunspot

  let(:user){ User.create(user_name: 'user', password: 'password') }

  describe "#credit_card_register" do
    it "はPaymentVeritransTxn::authorizeに引数を渡す" do
      PaymentVeritransTxn.should_receive(:authorize) do |inst, card_info|
        inst.should == user
        card_info.should include(
          number: '4111111111111111',
          expire: '04/23',
          security_code: '713'
        )
      end
      user.credit_card_register(
        number: '4111111111111111',
        expire: '04/23',
        security_code: '713',
      )
    end
  end

  describe "#payment" do
    before(:each) do
      (1..5).each do |i|
        FactoryGirl.create(:payment_veritrans_txn, {
          user: user,
          order_id: i,
          mstatus: PaymentVeritransTxn::Status::SUCCESS,
          created_at: Time.now,
        })
      end
    end

    (1..10).map{ rand(1..1000) }.each do |arg|
      it "は最後のレコードのPaymentVeritransTxn#paymentの引数に#{arg}を渡す" do
        txn = PaymentVeritransTxn.last
        txn.should_receive(:payment).with(arg)
        user.stub(:payment_veritrans_txns) { PaymentVeritransTxn }
        PaymentVeritransTxn.stub(:available) { PaymentVeritransTxn }
        PaymentVeritransTxn.stub(:last) { txn }
        user.payment(arg)
      end
    end

    it "はPaymentVeritransTxnのレコードがない場合PaymentNotRegisteredError例外をraiseする" do
      PaymentVeritransTxn.delete_all
      # precondition
      PaymentVeritransTxn.count.should == 0

      # test
      expect {
        user.payment(1)
      }.to raise_error(PaymentFailedError)
    end

    it "は処理中に何らかの例外がraiseされた場合はPaymentFailedError例外をraiseする" do
        txn = PaymentVeritransTxn.last
        txn.should_receive(:payment).and_raise(StandardError)
        user.stub(:payment_veritrans_txns) { PaymentVeritransTxn }
        PaymentVeritransTxn.stub(:available) { PaymentVeritransTxn }
        PaymentVeritransTxn.stub(:last) { txn }
        expect {
          user.payment(101)
        }.to raise_error(PaymentFailedError)
    end
  end

  describe '#absent_days' do
    it '最終アクセス日からの経過日数を返す' do
      user.stub(:last_request_at){Time.current}
      user.absent_days.should == 0

      user.stub(:last_request_at){1.day.ago}
      user.absent_days.should == 1

      user.stub(:last_request_at){2.days.ago}
      user.absent_days.should == 2

      user.stub(:last_request_at){1000.days.ago}
      user.absent_days.should == 1000
    end
  end

  describe '#revive' do
    before(:each) do
      user.leave('no reason')
    end

    it '最終アクセス時刻を現在時刻にする' do
      user.revive.should be_true
      user.last_request_at.should_not be_nil
      user.last_request_at.to_i.should be_within(1).of(Time.current.to_i)
    end
  end
end
