# encoding: utf-8
require 'spec_helper'

describe PaymentVeritransTxn do
  disconnect_sunspot

  let(:parent) {FactoryGirl.create(:parent)}

  def random_string
    SecureRandom.hex(rand(20))
  end

  context "scope" do
    before(:each) do
      @success_count, @failure_count, @pending_count = [
        rand(100..150), rand(100..150), rand(100..150)
      ]
      1.upto(@success_count) do |count|
        FactoryGirl.create(:payment_veritrans_txn, {
          mstatus: PaymentVeritransTxn::Status::SUCCESS,
          created_at: 0,
        })
      end
      1.upto(@failure_count) do |count|
        FactoryGirl.create(:payment_veritrans_txn, {
          mstatus: PaymentVeritransTxn::Status::FAILURE,
          created_at: 0,
        })
      end
      1.upto(@pending_count) do |count|
        FactoryGirl.create(:payment_veritrans_txn, {
          mstatus: PaymentVeritransTxn::Status::PENDING,
          created_at: 0,
        })
      end
    end

    context "success" do
      it "はmstatusが#{PaymentVeritransTxn::Status::SUCCESS}のものだけ返す" do
        PaymentVeritransTxn.success.count.should == @success_count
      end
    end

    context "pending" do
      it "はmstatusが#{PaymentVeritransTxn::Status::PENDING}のものだけ返す" do
        PaymentVeritransTxn.pending.count.should == @pending_count
      end
    end

    context "failure" do
      it "はmstatusが#{PaymentVeritransTxn::Status::FAILURE}のものだけ返す" do
        PaymentVeritransTxn.failure.count.should == @failure_count
      end
    end

    context "available" do
      [
        # offset, expect
        [-2, 50],
        [-1, 50],
        [0, 50],
        [1, 0],
        [2, 0],
      ].each do |offset, expect_value|
        it "はmstatusが#{PaymentVeritransTxn::Status::SUCCESS}かつcreated_atから#{PaymentVeritransTxn::MAX_STORAGE_DAYS}日以上過ぎていないものだけ返す" do
          PaymentVeritransTxn.where('mstatus = ?', PaymentVeritransTxn::Status::SUCCESS). \
            limit(50).update_all(
              created_at: (PaymentVeritransTxn::MAX_STORAGE_DAYS + offset).days.ago)
          PaymentVeritransTxn.where('mstatus = ?', PaymentVeritransTxn::Status::FAILURE). \
            limit(50).update_all(
              created_at: (PaymentVeritransTxn::MAX_STORAGE_DAYS + offset).days.ago)
          PaymentVeritransTxn.where('mstatus = ?', PaymentVeritransTxn::Status::PENDING). \
            limit(50).update_all(
              created_at: (PaymentVeritransTxn::MAX_STORAGE_DAYS + offset).days.ago)
          PaymentVeritransTxn.available.count.should == expect_value
        end
      end
    end
  end

  context "::MAX_STORAGE_DAYS" do
    it "should be 400" do
      PaymentVeritransTxn::MAX_STORAGE_DAYS.should == 400
    end
  end

  context "::Status" do
    context "::SUCCESS" do
      it "should be 'success'" do
        PaymentVeritransTxn::Status::SUCCESS.should == 'success'
      end
    end

    context "::PENDING" do
      it "should be 'pending'" do
        PaymentVeritransTxn::Status::PENDING.should == 'pending'
      end
    end

    context "::FAILURE" do
      it "should be 'failure'" do
        PaymentVeritransTxn::Status::FAILURE.should == 'failure'
      end
    end
  end

  context "::authorize" do
    before(:each) do
      @req = Veritrans::Tercerog::Mdk::CardAuthorizeRequestDto.new
      Veritrans::Tercerog::Mdk::CardAuthorizeRequestDto.stub(:new) { @req }
      @res = Veritrans::Tercerog::Mdk::CardAuthorizeResponseDto.new
      Veritrans::Tercerog::Mdk::CardAuthorizeResponseDto.stub(:new) { @res }
      [
        :v_result_code,
        :cust_txn,
        :march_txn,
        :service_type,
        # :mstatus,
        :txn_version,
        :card_transactiontype,
        :gateway_request_date,
        :gateway_response_date,
        :center_request_date,
        :center_response_date,
        :pending,
        :loopback,
        :connected_center_id,
        :req_amount,
        :req_item_code,
        :req_with_capture,
        :req_return_reference_number,
        :req_auth_code,
        :res_action_code,
        :acquirer_code,
      ].each do |attr|
        @res.send("#{attr}=", random_string)
      end
      @res.mstatus = PaymentVeritransTxn::Status::SUCCESS
      trans = Veritrans::Tercerog::Mdk::MdkTransaction.new
      Veritrans::Tercerog::Mdk::MdkTransaction.stub(:new) { trans }
      trans.should_receive(:execute) do |req|
        req.order_id.should == @req.order_id
        req.amount.should == '1'
        req.card_number.should == @req.card_number
        req.card_expire.should == @req.card_expire
        req.with_capture.should == 'false'
        req.security_code.should == @req.security_code

        @res.order_id = req.order_id
        @res
      end
    end

    it "でデータが保存される" do
      expect {
        PaymentVeritransTxn.authorize(parent)
      }.to change { PaymentVeritransTxn.count }.from(0).to(1)
      txn = PaymentVeritransTxn.first
      txn.user.should == parent
      txn.order_id.should == @res.order_id
      txn.v_result_code.should == @res.v_result_code
      txn.cust_txn.should == @res.cust_txn
      txn.march_txn.should == @res.march_txn
      txn.service_type.should == @res.service_type
      txn.mstatus.should == @res.mstatus
      txn.txn_version.should == @res.txn_version
      txn.card_transactiontype.should == @res.card_transactiontype
      txn.gateway_request_date.should == @res.gateway_request_date
      txn.gateway_response_date.should == @res.gateway_response_date
      txn.center_request_date.should == @res.center_request_date
      txn.center_response_date.should == @res.center_response_date
      txn.pending.should == @res.pending
      txn.loopback.should == @res.loopback
      txn.connected_center_id.should == @res.connected_center_id
      txn.amount.should == @res.req_amount
      txn.item_code.should == @res.req_item_code
      txn.with_capture.should == @res.req_with_capture
      txn.return_reference_number.should == @res.req_return_reference_number
      txn.auth_code.should == @res.req_auth_code
      txn.action_code.should == @res.res_action_code
      txn.acquirer_code.should == @res.acquirer_code
    end

    it "が成功ならtrueが返される" do
      PaymentVeritransTxn.authorize(parent).should be_true
    end

    it "が失敗ならfalseが返される" do
      @res.mstatus = PaymentVeritransTxn::Status::FAILURE
      PaymentVeritransTxn.authorize(parent).should be_false
    end

    context "card_info引数を渡して実行" do
      it "するとcard_infoの情報でリクエストされる" do
        PaymentVeritransTxn.authorize(parent, {
          number: 'test_card_number',
          expire: 'test_card_expire',
          security_code: 'test_security_code',
        })
        @req.card_number.should == 'test_card_number'
        @req.card_expire.should == 'test_card_expire'
        @req.security_code.should == 'test_security_code'
      end
    end
  end

  context "#payment" do
    before(:each) do
      @txn = PaymentVeritransTxn.create(user: parent, order_id: random_string)
      @req = Veritrans::Tercerog::Mdk::CardReAuthorizeRequestDto.new
      Veritrans::Tercerog::Mdk::CardReAuthorizeRequestDto.stub(:new) { @req }
      @res = Veritrans::Tercerog::Mdk::CardReAuthorizeResponseDto.new
      Veritrans::Tercerog::Mdk::CardReAuthorizeResponseDto.stub(:new) { @res }
      [
        :v_result_code,
        :cust_txn,
        :march_txn,
        :service_type,
        # :mstatus,
        :txn_version,
        :card_transactiontype,
        :gateway_request_date,
        :gateway_response_date,
        :center_request_date,
        :center_response_date,
        :pending,
        :loopback,
        :connected_center_id,
        :req_amount,
        :req_item_code,
        :req_with_capture,
        :req_return_reference_number,
        :req_auth_code,
        :res_action_code,
        :acquirer_code,
      ].each do |attr|
        @res.send("#{attr}=", random_string)
      end
      @res.mstatus = PaymentVeritransTxn::Status::SUCCESS
      trans = Veritrans::Tercerog::Mdk::MdkTransaction.new
      Veritrans::Tercerog::Mdk::MdkTransaction.stub(:new) { trans }
      trans.should_receive(:execute) do |req|
        req.order_id.should == @req.order_id
        req.original_order_id.should == @txn.order_id
        req.amount.should == @req.amount
        req.with_capture.should == 'true'

        @res.order_id = req.order_id
        @res
      end
    end

    it "でデータが保存される" do
      expect {
        @txn.payment(1)
      }.to change { PaymentVeritransTxn.count }.from(1).to(2)
      txn = PaymentVeritransTxn.find_by_order_id(@req.order_id)
      txn.user.should == parent
      txn.order_id.should == @res.order_id
      txn.v_result_code.should == @res.v_result_code
      txn.cust_txn.should == @res.cust_txn
      txn.march_txn.should == @res.march_txn
      txn.service_type.should == @res.service_type
      txn.mstatus.should == @res.mstatus
      txn.txn_version.should == @res.txn_version
      txn.card_transactiontype.should == @res.card_transactiontype
      txn.gateway_request_date.should == @res.gateway_request_date
      txn.gateway_response_date.should == @res.gateway_response_date
      txn.center_request_date.should == @res.center_request_date
      txn.center_response_date.should == @res.center_response_date
      txn.pending.should == @res.pending
      txn.loopback.should == @res.loopback
      txn.connected_center_id.should == @res.connected_center_id
      txn.amount.should == @res.req_amount
      txn.item_code.should == @res.req_item_code
      txn.with_capture.should == @res.req_with_capture
      txn.return_reference_number.should == @res.req_return_reference_number
      txn.auth_code.should == @res.req_auth_code
      txn.action_code.should == @res.res_action_code
      txn.acquirer_code.should == @res.acquirer_code
    end

    it "が成功ならtrueが返される" do
      @txn.payment(1).should be_true
    end

    it "が失敗ならfalseが返される" do
      @res.mstatus = PaymentVeritransTxn::Status::FAILURE
      @txn.payment(1).should be_false
    end

    (0..10).each do
      amount = rand(1000)
      context "引数に#{amount}を渡して実行" do
        it "すると文字列の#{amount}でリクエストされる" do
          @txn.payment(amount)
          @req.amount.should == amount.to_s
        end
      end
    end
  end
end
