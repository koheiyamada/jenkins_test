class PaymentVeritransTxn < ActiveRecord::Base
  belongs_to :user
  attr_protected :id

  MAX_STORAGE_DAYS = 400

  module Status
    SUCCESS = 'success'
    PENDING = 'pending'
    FAILURE = 'failure'
  end

  scope :success, where(:mstatus => Status::SUCCESS)
  scope :pending, where(:mstatus => Status::PENDING)
  scope :failure, where(:mstatus => Status::FAILURE)
  scope :available, where('mstatus = ? AND created_at >= ?', Status::SUCCESS, MAX_STORAGE_DAYS.days.ago)

  class << self
    def authorize(user, card_info = {})
      card_info = {
        number: '',
        expire: 'MM/YY',
        security_code: '',
      }.merge(card_info)
      req = Veritrans::Tercerog::Mdk::CardAuthorizeRequestDto.new
      req.order_id = generate_order_id(user)
      req.amount = '1'  # temporary
      req.card_number = card_info[:number].to_s
      req.card_expire = card_info[:expire].to_s
      req.with_capture = 'false'  # 与信のみ
      req.security_code = card_info[:security_code].to_s
      txn = request_and_create!(user, req)
      txn.mstatus == Status::SUCCESS
    end

    def generate_order_id(user)
      "aidnet_%d_%d" % [user.id, DateTime.now]
    end

    def request_and_create!(user, req)
      res = Veritrans::Tercerog::Mdk::MdkTransaction.new.execute(req)
      create!(
        user: user,
        order_id: res.order_id,
        v_result_code: res.v_result_code,
        cust_txn: res.cust_txn,
        march_txn: res.march_txn,
        service_type: res.service_type,
        mstatus: res.mstatus,
        txn_version: res.txn_version,
        card_transactiontype: res.card_transactiontype,
        gateway_request_date: res.gateway_request_date,
        gateway_response_date: res.gateway_response_date,
        center_request_date: res.center_request_date,
        center_response_date: res.center_response_date,
        pending: res.pending,
        loopback: res.loopback,
        connected_center_id: res.connected_center_id,
        amount: res.req_amount,
        item_code: res.req_item_code,
        with_capture: res.req_with_capture,
        return_reference_number: res.req_return_reference_number,
        auth_code: res.req_auth_code,
        action_code: res.res_action_code,
        acquirer_code: res.acquirer_code,
      )
    end
  end

  def payment(amount)
    req = Veritrans::Tercerog::Mdk::CardReAuthorizeRequestDto.new
    req.order_id = self.class.generate_order_id(user)
    req.original_order_id = order_id
    req.amount = amount.to_s
    req.with_capture = 'true'  # 与信と売上を同時に行なう
    txn = self.class.request_and_create!(user, req)
    txn.mstatus == Status::SUCCESS
  end

  ######## インスタンスの持つOrderIDで取引結果を取得
  def get_order_information
    common_param = Veritrans::Tercerog::Mdk::CommonSearchParameter.new
    common_param.order_id = order_id
    search_param = Veritrans::Tercerog::Mdk::SearchParameters.new
    search_param.common = common_param
    req = Veritrans::Tercerog::Mdk::SearchRequestDto.new
    req.search_parameters = search_param
    req.max_count = "1" #最大検索結果
    req.contain_dummy_flag = "1" #ダミー決済を検索結果に含めるかのフラグ
    res = Veritrans::Tercerog::Mdk::MdkTransaction.new.execute(req)
    res
  end
end
