# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      #=検索結果:固有トランザクション情報のクラス
      #
      # @author:: t.honma
      #
      class ProperTransactionInfo

        #
        # コンストラクタ。
        #
        def initialize
            @center_messages = Veritrans::Tercerog::Mdk::BaseDto.new
        end

        #
        # トランザクション種別を取得する
        # @return:: トランザクション種別
        #
        def txn_kind
            @txn_kind
        end

        #
        # トランザクション種別を設定する
        # @param:: トランザクション種別
        #
        def txn_kind=(txnKind)
            @txn_kind = txnKind
        end

        #
        # 取引対象タイプを取得する
        #
        # @return:: 取引対象タイプ
        #
        def em_txn_type
            @em_txn_type
        end

        #
        # 取引対象タイプを設定する
        #
        # @param:: emTxnType 取引対象タイプ
        #
        def em_txn_type=(emTxnType)
            @em_txn_type = emTxnType
        end

        #
        # 取引日時を取得する
        #
        # @return:: 取引日時
        #
        def center_proc_datetime
            @center_proc_datetime
        end

        #
        # 取引日時を設定する
        #
        # @param:: centerProcDatetime 取引日時
        #
        def center_proc_datetime=(centerProcDatetime)
            @center_proc_datetime = centerProcDatetime
        end

        #
        # 取引対象タイプを取得する
        #
        # @return:: 取引対象タイプ
        #
        def cvs_txn_type
            @cvs_txn_type
        end

        #
        # 取引対象タイプを設定する
        #
        # @param:: cvsTxnType 取引対象タイプ
        #
        def cvs_txn_type=(cvsTxnType)
            @cvs_txn_type = cvsTxnType
        end

        #
        # 対象取引タイプを取得する
        #
        # @return:: 対象取引タイプ
        #
        def pe_txn_type
            @pe_txn_type
        end

        #
        # 対象取引タイプを設定する
        #
        # @param:: peTxnType 対象取引タイプ
        #
        def pe_txn_type=(peTxnType)
            @pe_txn_type = peTxnType
        end

        #
        # 受付番号を取得する
        #
        # @return:: 受付番号
        #
        def receipt_no
            @receipt_no
        end

        #
        # 受付番号を設定する
        #
        # @param:: receiptNo 受付番号
        #
        def receipt_no=(receiptNo)
            @receipt_no = receiptNo
        end

        #
        # 取引日時を取得する
        #
        # @return:: 取引日時
        #
        def start_datetime
            @start_datetime
        end

        #
        # 取引日時を設定する
        #
        # @param:: startDatetime 取引日時
        #
        def start_datetime=(startDatetime)
            @start_datetime = startDatetime
        end

        #
        # カードトランザクションタイプを取得する
        #
        # @return:: カードトランザクションタイプ
        #
        def card_transaction_type
            @card_transaction_type
        end

        #
        # カードトランザクションタイプを設定する
        #
        # @param:: cardTransactionType カードトランザクションタイプ
        #
        def card_transaction_type=(cardTransactionType)
            @card_transaction_type = cardTransactionType
        end

        #
        # ゲートウェイ要求日時を取得する
        #
        # @return:: ゲートウェイ要求日時
        #
        def gateway_request_date
            @gateway_request_date
        end

        #
        # ゲートウェイ要求日時を設定する
        #
        # @param:: gatewayRequestDate ゲートウェイ要求日時
        #
        def gateway_request_date=(gatewayRequestDate)
            @gateway_request_date = gatewayRequestDate
        end

        #
        # ゲートウェイ応答日時を取得する
        #
        # @return:: ゲートウェイ応答日時
        #
        def gateway_response_date
            @gateway_response_date
        end

        #
        # ゲートウェイ応答日時を設定する
        #
        # @param:: gatewayResponseDate ゲートウェイ応答日時
        #
        def gateway_response_date=(gatewayResponseDate)
            @gateway_response_date = gatewayResponseDate
        end

        #
        # センター要求日時を取得する
        #
        # @return:: センター要求日時
        #
        def center_request_date
            @center_request_date
        end

        #
        # センター要求日時を設定する
        #
        # @param:: centerRequestDate センター要求日時
        #
        def center_request_date=(centerRequestDate)
            @center_request_date = centerRequestDate
        end

        #
        # センター応答日時を取得する
        #
        # @return:: センター応答日時
        #
        def center_response_date
            @center_response_date
        end

        #
        # センター応答日時を設定する
        #
        # @param:: centerResponseDate センター応答日時
        #
        def center_response_date=(centerResponseDate)
            @center_response_date = centerResponseDate
        end

        #
        # センター要求番号を取得する
        #
        # @return:: センター要求番号
        #
        def center_request_number
            @center_request_number
        end

        #
        # センター要求番号を設定する
        #
        # @param:: centerRequestNumber センター要求番号
        #
        def center_request_number=(centerRequestNumber)
            @center_request_number = centerRequestNumber
        end

        #
        # センターリファレンス番号を取得する
        #
        # @return:: センターリファレンス番号
        #
        def center_reference_number
            @center_reference_number
        end

        #
        # センターリファレンス番号を設定する
        #
        # @param:: centerReferenceNumber センターリファレンス番号
        #
        def center_reference_number=(centerReferenceNumber)
            @center_reference_number = centerReferenceNumber
        end

        #
        # 要求商品コードを取得する
        #
        # @return:: 要求商品コード
        #
        def req_item_code
            @req_item_code
        end

        #
        # 要求商品コードを設定する
        #
        # @param:: reqItemCode 要求商品コード
        #
        def req_item_code=(reqItemCode)
            @req_item_code = reqItemCode
        end

        #
        # 応答商品コードを取得する
        #
        # @return:: 応答商品コード
        #
        def res_item_code
            @res_item_code
        end

        #
        # 応答商品コードを設定する
        #
        # @param:: resItemCode 応答商品コード
        #
        def res_item_code=(resItemCode)
            @res_item_code = resItemCode
        end

        #
        # 要求リターン参照番号を取得する
        #
        # @return:: 要求リターン参照番号
        #
        def req_return_reference_number
            @req_return_reference_number
        end

        #
        # 要求リターン参照番号を設定する
        #
        # @param:: reqReturnReferenceNumber 要求リターン参照番号
        #
        def req_return_reference_number=(reqReturnReferenceNumber)
            @req_return_reference_number = reqReturnReferenceNumber
        end

        #
        # 応答データを取得する
        #
        # @return:: 応答データ
        #
        def responsedata
            @responsedata
        end

        #
        # 応答データを設定する
        #
        # @param:: responsedata 応答データ
        #
        def responsedata=(responsedata)
            @responsedata = responsedata
        end

        #
        # ペンディングを取得する
        #
        # @return:: ペンディング
        #
        def pending
            @pending
        end

        #
        # ペンディングを設定する
        #
        # @param:: pending ペンディング
        #
        def pending=(pending)
            @pending = pending
        end

        #
        # ループバックを取得する
        #
        # @return:: ループバック
        #
        def loopback
            @loopback
        end

        #
        # ループバックを設定する
        #
        # @param:: loopback ループバック
        #
        def loopback=(loopback)
            @loopback = loopback
        end

        #
        # 接続先カード接続センターを取得する
        #
        # @return:: 接続先カード接続センター
        #
        def connected_center_id
            @connected_center_id
        end

        #
        # 接続先カード接続センターを設定する
        #
        # @param:: connectedCenterId 接続先カード接続センター
        #
        def connected_center_id=(connectedCenterId)
            @connected_center_id = connectedCenterId
        end

        #
        # 要求カード番号を取得する
        #
        # @return:: 要求カード番号
        #
        def req_card_number
            @req_card_number
        end

        #
        # 要求カード番号を設定する
        #
        # @param:: reqCardNumber 要求カード番号
        #
        def req_card_number=(reqCardNumber)
            @req_card_number = reqCardNumber
        end

        #
        # 要求カード有効期限を取得する
        #
        # @return:: 要求カード有効期限
        #
        def req_card_expire
            @req_card_expire
        end

        #
        # 要求カード有効期限を設定する
        #
        # @param:: reqCardExpire 要求カード有効期限
        #
        def req_card_expire=(reqCardExpire)
            @req_card_expire = reqCardExpire
        end

        #
        # 要求カードオプションタイプを取得する
        #
        # @return:: 要求カードオプションタイプ
        #
        def req_amount
            @req_amount
        end

        #
        # 要求カードオプションタイプを設定する
        #
        # @param:: reqAmount 要求カードオプションタイプ
        #
        def req_amount=(reqAmount)
            @req_amount = reqAmount
        end

        #
        # 要求取引金額を取得する
        #
        # @return:: 要求取引金額
        #
        def req_card_option_type
            @req_card_option_type
        end

        #
        # 要求取引金額を設定する
        #
        # @param:: reqCardOptionType 要求取引金額
        #
        def req_card_option_type=(reqCardOptionType)
            @req_card_option_type = reqCardOptionType
        end

        #
        # 要求マーチャントトランザクション番号を取得する
        #
        # @return:: 要求マーチャントトランザクション番号
        #
        def req_merchant_transaction
            @req_merchant_transaction
        end

        #
        # 要求マーチャントトランザクション番号を設定する
        #
        # @param:: reqMerchantTransaction 要求マーチャントトランザクション番号
        #
        def req_merchant_transaction=(reqMerchantTransaction)
            @req_merchant_transaction = reqMerchantTransaction
        end

        #
        # 要求承認番号を取得する
        #
        # @return:: 要求承認番号
        #
        def req_auth_code
            @req_auth_code
        end

        #
        # 要求承認番号を設定する
        #
        # @param:: reqAuthCode 要求承認番号
        #
        def req_auth_code=(reqAuthCode)
            @req_auth_code = reqAuthCode
        end

        #
        # 要求仕向先コードを取得する
        #
        # @return:: 要求仕向先コード
        #
        def req_acquirer_code
            @req_acquirer_code
        end

        #
        # 要求仕向先コードを設定する
        #
        # @param:: reqAcquirerCode 要求仕向先コード
        #
        def req_acquirer_code=(reqAcquirerCode)
            @req_acquirer_code = reqAcquirerCode
        end

        #
        # 要求カードセンターを取得する
        #
        # @return:: 要求カードセンター
        #
        def req_card_center
            @req_card_center
        end

        #
        # 要求カードセンターを設定する
        #
        # @param:: reqCardCenter 要求カードセンター
        #
        def req_card_center=(reqCardCenter)
            @req_card_center = reqCardCenter
        end

        #
        # 要求JPO情報を取得する
        #
        # @return:: 要求JPO情報
        #
        def req_jpo_information
            @req_jpo_information
        end

        #
        # 要求JPO情報を設定する
        #
        # @param:: reqJpoInformation 要求JPO情報
        #
        def req_jpo_information=(reqJpoInformation)
            @req_jpo_information = reqJpoInformation
        end

        #
        # 要求売上日を取得する
        #
        # @return:: 要求売上日
        #
        def req_sales_day
            @req_sales_day
        end

        #
        # 要求売上日を設定する
        #
        # @param:: reqSalesDay 要求売上日
        #
        def req_sales_day=(reqSalesDay)
            @req_sales_day = reqSalesDay
        end

        #
        # 要求取消日を取得する
        #
        # @return:: 要求取消日
        #
        def req_cancel_day
            @req_cancel_day
        end

        #
        # 要求取消日を設定する
        #
        # @param:: reqCancelDay 要求取消日
        #
        def req_cancel_day=(reqCancelDay)
            @req_cancel_day = reqCancelDay
        end

        #
        # 要求同時売上を取得する
        #
        # @return:: 要求同時売上
        #
        def req_with_capture
            @req_with_capture
        end

        #
        # 要求同時売上を設定する
        #
        # @param:: reqWithCapture 要求同時売上
        #
        def req_with_capture=(reqWithCapture)
            @req_with_capture = reqWithCapture
        end

        #
        # 要求同時直接を取得する
        #
        # @return:: 要求同時直接
        #
        def req_with_direct
            @req_with_direct
        end

        #
        # 要求同時直接を設定する
        #
        # @param:: reqWithDirect 要求同時直接
        #
        def req_with_direct=(reqWithDirect)
            @req_with_direct = reqWithDirect
        end

        #
        # 要求3Dメッセージバージョンを取得する
        #
        # @return:: 要求3Dメッセージバージョン
        #
        def req3d_message_version
            @req3d_message_version
        end

        #
        # 要求3Dメッセージバージョンを設定する
        #
        # @param:: req3dMessageVersion 要求3Dメッセージバージョン
        #
        def req3d_message_version=(req3dMessageVersion)
            @req3d_message_version = req3dMessageVersion
        end

        #
        # 要求3DトランザクションIDを取得する
        #
        # @return:: 要求3DトランザクションID
        #
        def req3d_transaction_id
            @req3d_transaction_id
        end

        #
        # 要求3DトランザクションIDを設定する
        #
        # @param:: req3dTransactionId 要求3DトランザクションID
        #
        def req3d_transaction_id=(req3dTransactionId)
            @req3d_transaction_id = req3dTransactionId
        end

        #
        # 要求3Dトランザクションステータスを取得する
        #
        # @return:: 要求3Dトランザクションステータス
        #
        def req3d_transaction_status
            @req3d_transaction_status
        end

        #
        # 要求3Dトランザクションステータスを設定する
        #
        # @param:: req3dTransactionStatus 要求3Dトランザクションステータス
        #
        def req3d_transaction_status=(req3dTransactionStatus)
            @req3d_transaction_status = req3dTransactionStatus
        end

        #
        # 要求3D CAVVアルゴリズムを取得する
        #
        # @return:: 要求3D CAVVアルゴリズム
        #
        def req3d_cavv_algorithm
            @req3d_cavv_algorithm
        end

        #
        # 要求3D CAVVアルゴリズムを設定する
        #
        # @param:: req3dCavvAlgorithm 要求3D CAVVアルゴリズム
        #
        def req3d_cavv_algorithm=(req3dCavvAlgorithm)
            @req3d_cavv_algorithm = req3dCavvAlgorithm
        end

        #
        # 要求3D CAVVを取得する
        #
        # @return:: 要求3D CAVV
        #
        def req3d_cavv
            @req3d_cavv
        end

        #
        # 要求3D CAVVを設定する
        #
        # @param:: req3dCavv 要求3D CAVV
        #
        def req3d_cavv=(req3dCavv)
            @req3d_cavv = req3dCavv
        end

        #
        # 要求3D ECIを取得する
        #
        # @return:: 要求3D ECI
        #
        def req3d_eci
            @req3d_eci
        end

        #
        # 要求3D ECIを設定する
        #
        # @param:: req3dEci 要求3D ECI
        #
        def req3d_eci=(req3dEci)
            @req3d_eci = req3dEci
        end

        #
        # 要求セキュリティコードを取得する
        #
        # @return:: 要求セキュリティコード
        #
        def req_security_code
            @req_security_code
        end

        #
        # 要求セキュリティコードを設定する
        #
        # @param:: reqSecurityCode 要求セキュリティコード
        #
        def req_security_code=(reqSecurityCode)
            @req_security_code = reqSecurityCode
        end

        #
        # 要求認証番号を取得する
        #
        # @return:: 要求認証番号
        #
        def req_auth_flag
            @req_auth_flag
        end

        #
        # 要求認証番号を設定する
        #
        # @param:: reqAuthFlag 要求認証番号
        #
        def req_auth_flag=(reqAuthFlag)
            @req_auth_flag = reqAuthFlag
        end

        #
        # 要求誕生日を取得する
        #
        # @return:: 要求誕生日
        #
        def req_birthday
            @req_birthday
        end

        #
        # 要求誕生日を設定する
        #
        # @param:: reqBirthday 要求誕生日
        #
        def req_birthday=(reqBirthday)
            @req_birthday = reqBirthday
        end

        #
        # 要求電話番号を取得する
        #
        # @return:: 要求電話番号
        #
        def req_tel
            @req_tel
        end

        #
        # 要求電話番号を設定する
        #
        # @param:: reqTel 要求電話番号
        #
        def req_tel=(reqTel)
            @req_tel = reqTel
        end

        #
        # 要求カナ名前（名）を取得する
        #
        # @return:: 要求カナ名前（名）
        #
        def req_first_kana_name
            @req_first_kana_name
        end

        #
        # 要求カナ名前（名）を設定する
        #
        # @param:: reqFirstKanaName 要求カナ名前（名）
        #
        def req_first_kana_name=(reqFirstKanaName)
            @req_first_kana_name = reqFirstKanaName
        end

        #
        # 要求カナ名前（姓）を取得する
        #
        # @return:: 要求カナ名前（姓）
        #
        def req_last_kana_name
            @req_last_kana_name
        end

        #
        # 要求カナ名前（姓）を設定する
        #
        # @param:: reqLastKanaName 要求カナ名前（姓）
        #
        def req_last_kana_name=(reqLastKanaName)
            @req_last_kana_name = reqLastKanaName
        end

        #
        # 応答マーチャントトランザクション番号を取得する
        #
        # @return:: 応答マーチャントトランザクション番号
        #
        def res_merchant_transaction
            @res_merchant_transaction
        end

        #
        # 応答マーチャントトランザクション番号を設定する
        #
        # @param:: resMerchantTransaction 応答マーチャントトランザクション番号
        #
        def res_merchant_transaction=(resMerchantTransaction)
            @res_merchant_transaction = resMerchantTransaction
        end

        #
        # 応答リターン参照番号を取得する
        #
        # @return:: 応答リターン参照番号
        #
        def res_return_reference_number
            @res_return_reference_number
        end

        #
        # 応答リターン参照番号を設定する
        #
        # @param:: resReturnReferenceNumber 応答リターン参照番号
        #
        def res_return_reference_number=(resReturnReferenceNumber)
            @res_return_reference_number = resReturnReferenceNumber
        end

        #
        # 応答承認番号を取得する
        #
        # @return:: 応答承認番号
        #
        def res_auth_code
            @res_auth_code
        end

        #
        # 応答承認番号を設定する
        #
        # @param:: resAuthCode 応答承認番号
        #
        def res_auth_code=(resAuthCode)
            @res_auth_code = resAuthCode
        end

        #
        # アクションコードを取得する
        #
        # @return:: アクションコード
        #
        def res_action_code
            @res_action_code
        end

        #
        # アクションコードを設定する
        #
        # @param:: resActionCode アクションコード
        #
        def res_action_code=(resActionCode)
            @res_action_code = resActionCode
        end

        #
        # 応答センターエラーコードを取得する
        #
        # @return:: 応答センターエラーコード
        #
        def res_center_error_code
            @res_center_error_code
        end

        #
        # 応答センターエラーコードを設定する
        #
        # @param:: resCenterErrorCode 応答センターエラーコード
        #
        def res_center_error_code=(resCenterErrorCode)
            @res_center_error_code = resCenterErrorCode
        end

        #
        # 応答与信期間を取得する
        #
        # @return:: 応答与信期間
        #
        def res_auth_term
            @res_auth_term
        end

        #
        # 応答与信期間を設定する
        #
        # @param:: resAuthTerm 応答与信期間
        #
        def res_auth_term=(resAuthTerm)
            @res_auth_term = resAuthTerm
        end

        #
        # 要求新規返品を取得する
        #
        # @return:: 要求新規返品
        #
        def req_with_new
            @req_with_new
        end

        #
        # 要求新規返品を設定する
        #
        # @param:: reqWithNew 要求新規返品
        #
        def req_with_new=(reqWithNew)
            @req_with_new = reqWithNew
        end

        #
        # 取引金額を取得する
        #
        # @return:: 取引金額
        #
        def amount
            @amount
        end

        #
        # 取引金額を設定する
        #
        # @param:: amount 取引金額
        #
        def amount=(amount)
            @amount = amount
        end

        #
        # Paypal対象取引タイプを取得する
        #
        # @return:: 対象取引タイプ
        #
        def pp_txn_type
            @pp_txn_type
        end

        #
        # Paypal対象取引タイプを設定する
        #
        # @param:: ppTxnType 対象取引タイプ
        #
        def pp_txn_type=(ppTxnType)
            @pp_txn_type = ppTxnType
        end
        #
        # Paypal取引識別子を取得する
        #
        # @return:: 取引識別子
        #
        def center_txn_id
            @center_txn_id
        end

        #
        # Paypal取引識別子を設定する
        #
        # @param:: centerTxnId 取引識別子
        #
        def center_txn_id=(centerTxnId)
            @center_txn_id = centerTxnId
        end
        #
        # 手数料を取得する
        #
        # @return:: 手数料
        #
        def fee_amount
            @fee_amount
        end

        #
        # 手数料を設定する
        #
        # @param:: feeAmount 手数料
        #
        def fee_amount=(feeAmount)
            @fee_amount = feeAmount
        end
        #
        # Paypal外貨換算レートを取得する
        #
        # @return:: 外貨換算レート
        #
        def exchange_rate
            @exchange_rate
        end

        #
        # Paypal外貨換算レートを設定する
        #
        # @param:: exchangeRate 外貨換算レート
        #
        def exchange_rate=(exchangeRate)
            @exchange_rate = exchangeRate
        end
        #
        # Paypal純返金金額を取得する
        #
        # @return:: 純返金金額
        #
        def net_refund_amount
            @net_refund_amount
        end

        #
        # Paypal純返金金額を設定する
        #
        # @param:: netRefundAmount 純返金金額
        #
        def net_refund_amount=(netRefundAmount)
            @net_refund_amount = netRefundAmount
        end
        #
        # MPIトランザクションタイプを取得する
        #
        # @return:: MPIトランザクションタイプ
        #
        def mpi_transaction_type
            @mpi_transaction_type
        end

        #
        # MPIトランザクションタイプを設定する。
        #
        # @param:: mpiTransactionType MPIトランザクションタイプ
        #
        def mpi_transaction_type=(mpiTransactionType)
            @mpi_transaction_type = mpiTransactionType
        end

        #
        # リダイレクションURIを取得する
        #
        # @return:: リダイレクションURI
        #
        def req_redirection_uri
            @req_redirection_uri
        end

        #
        # リダイレクションURIを設定する
        #
        # @param:: reqRedirectionUri リダイレクションURI
        #
        def req_redirection_uri=(reqRedirectionUri)
            @req_redirection_uri = reqRedirectionUri
        end

        #
        # カード会社IDを取得する
        #
        # @return:: カード会社ID
        #
        def corporation_id
            @corporation_id
        end

        #
        # カード会社IDを設定する
        #
        # @param:: corporationId カード会社ID
        #
        def corporation_id=(corporationId)
            @corporation_id = corporationId
        end

        #
        # ブランドIDを取得する
        #
        # @return:: ブランドID
        #
        def brand_id
            @brand_id
        end

        #
        # ブランドIDを設定する
        # @param:: brandId ブランドID
        #
        def brand_id=(brandId)
            @brand_id = brandId
        end

        #
        # 仕向先バイナリを取得する
        #
        # @return:: 仕向先バイナリ
        #
        def acquirer_binary
            @acquirer_binary
        end

        #
        # 仕向先バイナリを取得する
        #
        # @param:: acquirerBinary 仕向先バイナリ
        #
        def acquirer_binary=(acquirerBinary)
            @acquirer_binary = acquirerBinary
        end

        #
        # ディレクトリサービスログインIDを取得する
        #
        # @return:: ディレクトリサービスログインID
        #
        def ds_login_id
            @ds_login_id
        end

        #
        # ディレクトリサービスログインIDを設定する
        #
        # @param:: dsLoginId ディレクトリサービスログインID
        #
        def ds_login_id=(dsLoginId)
            @ds_login_id = dsLoginId
        end

        #
        # CRRSステータスを取得する
        #
        # @return:: CRRSステータス
        #
        def crres_status
            @crres_status
        end

        #
        # CRRSステータスを設定する
        #
        # @param:: crresStatus  CRRSステータス
        #
        def crres_status=(crresStatus)
            @crres_status = crresStatus
        end

        #
        # VERESステータスを取得する
        #
        # @return:: VERESステータス
        #
        def veres_status
            @veres_status
        end

        #
        #  VERESステータスを設定する
        #
        # @param:: veresStatus  VERESステータス
        #
        def veres_status=(veresStatus)
            @veres_status = veresStatus
        end

        #
        # PARESサインを取得する
        #
        # @return:: PARESサイン
        #
        def pares_sign
            @pares_sign
        end

        #
        #  PARESサインを設定する
        #
        # @param:: paresSign  PARESサイン
        #
        def pares_sign=(paresSign)
             @pares_sign = paresSign
        end

        #
        # PARESステータスを取得する
        #
        # @return:: PARESステータス
        #
        def pares_status
            @pares_status
        end

        #
        #  PARESステータスを設定する
        # @param:: paresStatus PARESステータス
        #
        def pares_status=(paresStatus)
            @pares_status = paresStatus
        end

        #
        #  PARES ECIを取得する
        # @return::  PARES ECI
        #
        def pares_eci
            @pares_eci
        end

        #
        # PARES ECIを設定する
        # @param:: paresEci PARES ECI
        #
        def pares_eci=(paresEci)
            @pares_eci = paresEci
        end

        #
        # 本人認証レスポンスコードを取得する
        #
        # @return:: 本人認証レスポンスコード
        #
        def auth_response_code
            @auth_response_code
        end

        #
        # 本人認証レスポンスコードを設定する
        #
        # @param:: authResponseCode 本人認証レスポンスコード
        #
        def auth_response_code=(authResponseCode)
            @auth_response_code = authResponseCode
        end

        #
        # 検証レスポンスコードを取得する
        #
        # @return:: 検証レスポンスコード
        #
        def verify_response_code
            @verify_response_code
        end

        #
        # 検証レスポンスコードを設定する
        #
        # @param:: verifyResponseCode 検証レスポンスコード
        #
        def verify_response_code=(verifyResponseCode)
            @verify_response_code = verifyResponseCode
        end

        #
        # 応答3Dメッセージバージョンを取得する
        #
        # @return:: 応答3Dメッセージバージョン
        #
        def res3d_message_version
            @res3d_message_version
        end

        #
        # 応答3Dメッセージバージョンを設定する
        #
        # @param:: res3dMessageVersion 応答3Dメッセージバージョン
        #
        def res3d_message_version=(res3dMessageVersion)
            @res3d_message_version = res3dMessageVersion
        end

        #
        # 応答3DトランザクションIDを取得する
        #
        # @return:: 応答3DトランザクションID
        #
        def res3d_transaction_id
            @res3d_transaction_id
        end

        #
        # 応答3DトランザクションIDを設定する
        #
        # @param:: res3dTransactionId 応答3DトランザクションID
        #
        def res3d_transaction_id=(res3dTransactionId)
            @res3d_transaction_id = res3dTransactionId
        end

        #
        # 応答3Dトランザクションステータスを取得する
        #
        # @return:: 応答3Dトランザクションステータス
        #
        def res3d_transaction_status
            @res3d_transaction_status
        end

        #
        # 応答3Dトランザクションステータスを設定する
        #
        # @param:: res3dTransactionStatus 応答3Dトランザクションステータス
        #
        def res3d_transaction_status=(res3dTransactionStatus)
            @res3d_transaction_status = res3dTransactionStatus
        end

        #
        # 応答3D CAVV アルゴリズムを取得する
        #
        # @return:: 応答3D CAVV アルゴリズム
        #
        def res3d_cavv_algorithm
            @res3d_cavv_algorithm
        end

        #
        #  応答3D CAVV アルゴリズムを設定する
        #
        # @param:: res3dCavvAlgorithm  応答3D CAVV アルゴリズム
        #
        def res3d_cavv_algorithm=(res3dCavvAlgorithm)
            @res3d_cavv_algorithm = res3dCavvAlgorithm
        end

        #
        # 応答3D CAVVを取得する
        #
        # @return:: 応答3D CAVV
        #
        def res3d_cavv
            @res3d_cavv
        end

        #
        # 応答3D CAVV を設定する
        #
        # @param:: res3dCavv 応答3D CAVV
        #
        def res3d_cavv=(res3dCavv)
            @res3d_cavv = res3dCavv
        end

        #
        # 応答3D ECI を取得する
        #
        # @return:: 応答3D ECI
        #
        def res3d_eci
            @res3d_eci
        end

        #
        # 応答3D ECIを設定する
        #
        # @param:: res3dEci 応答3D ECI
        #
        def res3d_eci=(res3dEci)
            @res3d_eci = res3dEci
        end

        #
        # 本人認証要求日時を取得する
        #
        # @return:: 本人認証要求日時
        #
        def auth_request_datetime
          @auth_request_datetime
        end

        #
        # 本人認証要求日時を設定する
        #
        # @param:: authRequestDatetime 本人認証要求日時
        #
        def auth_request_datetime=(authRequestDatetime)
            @auth_request_datetime = authRequestDatetime
        end

        #
        # 本人認証応答日時を取得する
        #
        # @return:: 本人認証応答日時
        #
        def auth_response_datetime
            @auth_response_datetime
        end

        #
        # 本人認証応答日時を設定する
        #
        # @param:: authResponseDatetime 本人認証応答日時
        #
        def auth_response_datetime=(authResponseDatetime)
            @auth_response_datetime = authResponseDatetime
        end

        #
        # 検証要求日時を取得する
        #
        # @return:: 検証要求日時
        #
        def verify_request_datetime
            @verify_request_datetime
        end

        #
        # 検証要求日時を設定する
        # @param:: verifyRequestDatetime 検証要求日時
        #
        def verify_request_datetime=(verifyRequestDatetime)
            @verify_request_datetime = verifyRequestDatetime
        end

        #
        # 検証応答日時を取得する
        #
        # @return:: 検証応答日時
        #
        def verify_response_datetime
            @verify_response_datetime
        end

        #
        # 検証応答日時を設定する
        #
        # @param:: verifyResponseDatetime 検証応答日時
        #
        def verify_response_datetime=(verifyResponseDatetime)
            @verify_response_datetime = verifyResponseDatetime
        end

        #
        # 要求通貨単位を取得する
        #
        # @return:: 要求通貨単位
        #
        def req_currency_unit
            @req_currency_unit
        end

        #
        # 要求通貨単位を設定する
        #
        # @param:: reqCurrencyUnit 要求通貨単位
        #
        def req_currency_unit=(reqCurrencyUnit)
            @req_currency_unit = reqCurrencyUnit
        end

        #
        # ===永久不滅ウォレット残高を取得する
        #
        # @return:: 永久不滅ウォレット残高
        #
        def aq_aqf_wallet_balance
          @aq_aqf_wallet_balance
        end

        #
        # ===永久不滅ウォレット残高を設定する
        #
        # @param:: aqAqfWalletBalance 永久不滅ウォレット残高
        #
        def aq_aqf_wallet_balance=(aqAqfWalletBalance)
          @aq_aqf_wallet_balance = aqAqfWalletBalance
        end

        #
        # ===永久不滅ポイント残高を取得する
        #
        # @return:: 永久不滅ポイント残高
        #
        def aq_aqf_point_balance
          @aq_aqf_point_balance
        end

        #
        # ===永久不滅ポイント残高を設定する
        #
        # @param:: aqAqfPointBalance 永久不滅ポイント残高
        #
        def aq_aqf_point_balance=(aqAqfPointBalance)
          @aq_aqf_point_balance = aqAqfPointBalance
        end

        #
        # ===交換後利用可能バリューを取得する
        #
        # @return:: 交換後利用可能バリュー
        #
        def aq_available_value
          @aq_available_value
        end

        #
        # ===交換後利用可能バリューを設定する
        #
        # @param:: aqAvailableValue 交換後利用可能バリュー
        #
        def aq_available_value=(aqAvailableValue)
          @aq_available_value = aqAvailableValue
        end

        #
        # ===SaisonトランザクションAPIリストを取得する
        #
        # @return:: SaisonトランザクションAPIリスト
        #
        def transaction_apis
          @transaction_apis
        end

        #
        # ===SaisonトランザクションAPIリストを設定する
        #
        # @param:: transactionApis SaisonトランザクションAPIリスト
        #
        def transaction_apis=(transactionApis)
          @transaction_apis = transactionApis
        end

        #
        # ===Saisonトランザクションカードリストを取得する
        #
        # @return:: Saisonトランザクションカードリスト
        #
        def transaction_cards
          @transaction_cards
        end

        #
        # ===Saisonトランザクションカードリストを設定する
        #
        # @param:: transactionCards Saisonトランザクションカードリスト
        #
        def transaction_cards=(transactionCards)
          @transaction_cards = transactionCards
        end

      end
    end
  end
end