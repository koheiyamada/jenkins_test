# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/response_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：カード、コマンド名：申込の応答Dtoクラス
      #
      # @author:: Created automatically by EXCEL macro
      #
      class CardAuthorizeResponseDto < ::ResponseBaseDto

        #
        # ===決済サービスタイプを取得する
        # @return:: 決済サービスタイプ
        #
        def service_type
            @service_type
        end

        #
        # ===決済サービスタイプを設定する
        # @param :: serviceType 決済サービスタイプ
        #
        def service_type=(serviceType)
            @service_type = serviceType
        end

        #
        # ===処理結果コードを取得する
        # @return:: 処理結果コード
        #
        def mstatus
            @mstatus
        end

        #
        # ===処理結果コードを設定する
        # @param :: mstatus 処理結果コード
        #
        def mstatus=(mstatus)
            @mstatus = mstatus
        end

        #
        # ===詳細結果コードを取得する
        # @return:: 詳細結果コード
        #
        def v_result_code
            @v_result_code
        end

        #
        # ===詳細結果コードを設定する
        # @param :: vResultCode 詳細結果コード
        #
        def v_result_code=(vResultCode)
            @v_result_code = vResultCode
        end

        #
        # ===エラーメッセージを取得する
        # @return:: エラーメッセージ
        #
        def merr_msg
            @merr_msg
        end

        #
        # ===エラーメッセージを設定する
        # @param :: merrMsg エラーメッセージ
        #
        def merr_msg=(merrMsg)
            @merr_msg = merrMsg
        end

        #
        # ===電文IDを取得する
        # @return:: 電文ID
        #
        def march_txn
            @march_txn
        end

        #
        # ===電文IDを設定する
        # @param :: marchTxn 電文ID
        #
        def march_txn=(marchTxn)
            @march_txn = marchTxn
        end

        #
        # ===取引IDを取得する
        # @return:: 取引ID
        #
        def order_id
            @order_id
        end

        #
        # ===取引IDを設定する
        # @param :: orderId 取引ID
        #
        def order_id=(orderId)
            @order_id = orderId
        end

        #
        # ===取引毎に付くIDを取得する
        # @return:: 取引毎に付くID
        #
        def cust_txn
            @cust_txn
        end

        #
        # ===取引毎に付くIDを設定する
        # @param :: custTxn 取引毎に付くID
        #
        def cust_txn=(custTxn)
            @cust_txn = custTxn
        end

        #
        # ===MDK バージョンを取得する
        # - 電文のバージョン番号。
        # @return:: MDK バージョン
        #
        def txn_version
            @txn_version
        end

        #
        # ===MDK バージョンを設定する
        # @param :: txnVersion MDK バージョン
        #
        def txn_version=(txnVersion)
            @txn_version = txnVersion
        end

        #
        # ===カードトランザクションタイプを取得する
        # @return:: カードトランザクションタイプ
        #
        def card_transactiontype
            @card_transactiontype
        end

        #
        # ===カードトランザクションタイプを設定する
        # @param :: cardTransactiontype カードトランザクションタイプ
        #
        def card_transactiontype=(cardTransactiontype)
            @card_transactiontype = cardTransactiontype
        end

        #
        # ===ゲートウェイ要求日時を取得する
        # @return:: ゲートウェイ要求日時
        #
        def gateway_request_date
            @gateway_request_date
        end

        #
        # ===ゲートウェイ要求日時を設定する
        # @param :: gatewayRequestDate ゲートウェイ要求日時
        #
        def gateway_request_date=(gatewayRequestDate)
            @gateway_request_date = gatewayRequestDate
        end

        #
        # ===ゲートウェイ応答日時を取得する
        # @return:: ゲートウェイ応答日時
        #
        def gateway_response_date
            @gateway_response_date
        end

        #
        # ===ゲートウェイ応答日時を設定する
        # @param :: gatewayResponseDate ゲートウェイ応答日時
        #
        def gateway_response_date=(gatewayResponseDate)
            @gateway_response_date = gatewayResponseDate
        end

        #
        # ===センター要求日時を取得する
        # @return:: センター要求日時
        #
        def center_request_date
            @center_request_date
        end

        #
        # ===センター要求日時を設定する
        # @param :: centerRequestDate センター要求日時
        #
        def center_request_date=(centerRequestDate)
            @center_request_date = centerRequestDate
        end

        #
        # ===センター応答日時を取得する
        # @return:: センター応答日時
        #
        def center_response_date
            @center_response_date
        end

        #
        # ===センター応答日時を設定する
        # @param :: centerResponseDate センター応答日時
        #
        def center_response_date=(centerResponseDate)
            @center_response_date = centerResponseDate
        end

        #
        # ===ペンディングを取得する
        # @return:: ペンディング
        #
        def pending
            @pending
        end

        #
        # ===ペンディングを設定する
        # @param :: pending ペンディング
        #
        def pending=(pending)
            @pending = pending
        end

        #
        # ===ループバックを取得する
        # @return:: ループバック
        #
        def loopback
            @loopback
        end

        #
        # ===ループバックを設定する
        # @param :: loopback ループバック
        #
        def loopback=(loopback)
            @loopback = loopback
        end

        #
        # ===接続先カード接続センターを取得する
        # @return:: 接続先カード接続センター
        #
        def connected_center_id
            @connected_center_id
        end

        #
        # ===接続先カード接続センターを設定する
        # @param :: connectedCenterId 接続先カード接続センター
        #
        def connected_center_id=(connectedCenterId)
            @connected_center_id = connectedCenterId
        end

        #
        # ===センター要求番号を取得する
        # @return:: センター要求番号
        #
        def center_request_number
            @center_request_number
        end

        #
        # ===センター要求番号を設定する
        # @param :: centerRequestNumber センター要求番号
        #
        def center_request_number=(centerRequestNumber)
            @center_request_number = centerRequestNumber
        end

        #
        # ===センターリファレンス番号を取得する
        # @return:: センターリファレンス番号
        #
        def center_reference_number
            @center_reference_number
        end

        #
        # ===センターリファレンス番号を設定する
        # @param :: centerReferenceNumber センターリファレンス番号
        #
        def center_reference_number=(centerReferenceNumber)
            @center_reference_number = centerReferenceNumber
        end

        #
        # ===要求カード番号を取得する
        # @return:: 要求カード番号
        #
        def req_card_number
            @req_card_number
        end

        #
        # ===要求カード番号を設定する
        # @param :: reqCardNumber 要求カード番号
        #
        def req_card_number=(reqCardNumber)
            @req_card_number = reqCardNumber
        end

        #
        # ===要求カード有効期限を取得する
        # @return:: 要求カード有効期限
        #
        def req_card_expire
            @req_card_expire
        end

        #
        # ===要求カード有効期限を設定する
        # @param :: reqCardExpire 要求カード有効期限
        #
        def req_card_expire=(reqCardExpire)
            @req_card_expire = reqCardExpire
        end

        #
        # ===要求カードオプションタイプを取得する
        # @return:: 要求カードオプションタイプ
        #
        def req_card_option_type
            @req_card_option_type
        end

        #
        # ===要求カードオプションタイプを設定する
        # @param :: reqCardOptionType 要求カードオプションタイプ
        #
        def req_card_option_type=(reqCardOptionType)
            @req_card_option_type = reqCardOptionType
        end

        #
        # ===要求取引金額を取得する
        # @return:: 要求取引金額
        #
        def req_amount
            @req_amount
        end

        #
        # ===要求取引金額を設定する
        # @param :: reqAmount 要求取引金額
        #
        def req_amount=(reqAmount)
            @req_amount = reqAmount
        end

        #
        # ===要求マーチャントトランザクション番号を取得する
        # @return:: 要求マーチャントトランザクション番号
        #
        def req_merchant_transaction
            @req_merchant_transaction
        end

        #
        # ===要求マーチャントトランザクション番号を設定する
        # @param :: reqMerchantTransaction 要求マーチャントトランザクション番号
        #
        def req_merchant_transaction=(reqMerchantTransaction)
            @req_merchant_transaction = reqMerchantTransaction
        end

        #
        # ===要求リターン参照番号を取得する
        # @return:: 要求リターン参照番号
        #
        def req_return_reference_number
            @req_return_reference_number
        end

        #
        # ===要求リターン参照番号を設定する
        # @param :: reqReturnReferenceNumber 要求リターン参照番号
        #
        def req_return_reference_number=(reqReturnReferenceNumber)
            @req_return_reference_number = reqReturnReferenceNumber
        end

        #
        # ===要求承認番号を取得する
        # @return:: 要求承認番号
        #
        def req_auth_code
            @req_auth_code
        end

        #
        # ===要求承認番号を設定する
        # @param :: reqAuthCode 要求承認番号
        #
        def req_auth_code=(reqAuthCode)
            @req_auth_code = reqAuthCode
        end

        #
        # ===要求仕向先コードを取得する
        # @return:: 要求仕向先コード
        #
        def req_acquirer_code
            @req_acquirer_code
        end

        #
        # ===要求仕向先コードを設定する
        # @param :: reqAcquirerCode 要求仕向先コード
        #
        def req_acquirer_code=(reqAcquirerCode)
            @req_acquirer_code = reqAcquirerCode
        end

        #
        # ===要求商品コードを取得する
        # @return:: 要求商品コード
        #
        def req_item_code
            @req_item_code
        end

        #
        # ===要求商品コードを設定する
        # @param :: reqItemCode 要求商品コード
        #
        def req_item_code=(reqItemCode)
            @req_item_code = reqItemCode
        end

        #
        # ===要求カードセンターを取得する
        # @return:: 要求カードセンター
        #
        def req_card_center
            @req_card_center
        end

        #
        # ===要求カードセンターを設定する
        # @param :: reqCardCenter 要求カードセンター
        #
        def req_card_center=(reqCardCenter)
            @req_card_center = reqCardCenter
        end

        #
        # ===要求JPO情報を取得する
        # @return:: 要求JPO情報
        #
        def req_jpo_information
            @req_jpo_information
        end

        #
        # ===要求JPO情報を設定する
        # @param :: reqJpoInformation 要求JPO情報
        #
        def req_jpo_information=(reqJpoInformation)
            @req_jpo_information = reqJpoInformation
        end

        #
        # ===要求売上日を取得する
        # @return:: 要求売上日
        #
        def req_sales_day
            @req_sales_day
        end

        #
        # ===要求売上日を設定する
        # @param :: reqSalesDay 要求売上日
        #
        def req_sales_day=(reqSalesDay)
            @req_sales_day = reqSalesDay
        end

        #
        # ===要求取消日を取得する
        # @return:: 要求取消日
        #
        def req_cancel_day
            @req_cancel_day
        end

        #
        # ===要求取消日を設定する
        # @param :: reqCancelDay 要求取消日
        #
        def req_cancel_day=(reqCancelDay)
            @req_cancel_day = reqCancelDay
        end

        #
        # ===要求同時売上を取得する
        # @return:: 要求同時売上
        #
        def req_with_capture
            @req_with_capture
        end

        #
        # ===要求同時売上を設定する
        # @param :: reqWithCapture 要求同時売上
        #
        def req_with_capture=(reqWithCapture)
            @req_with_capture = reqWithCapture
        end

        #
        # ===要求同時直接を取得する
        # @return:: 要求同時直接
        #
        def req_with_direct
            @req_with_direct
        end

        #
        # ===要求同時直接を設定する
        # @param :: reqWithDirect 要求同時直接
        #
        def req_with_direct=(reqWithDirect)
            @req_with_direct = reqWithDirect
        end

        #
        # ===要求3Dメッセージバージョンを取得する
        # @return:: 要求3Dメッセージバージョン
        #
        def req3d_message_version
            @req3d_message_version
        end

        #
        # ===要求3Dメッセージバージョンを設定する
        # @param :: req3dMessageVersion 要求3Dメッセージバージョン
        #
        def req3d_message_version=(req3dMessageVersion)
            @req3d_message_version = req3dMessageVersion
        end

        #
        # ===要求3DトランザクションIDを取得する
        # @return:: 要求3DトランザクションID
        #
        def req3d_transaction_id
            @req3d_transaction_id
        end

        #
        # ===要求3DトランザクションIDを設定する
        # @param :: req3dTransactionId 要求3DトランザクションID
        #
        def req3d_transaction_id=(req3dTransactionId)
            @req3d_transaction_id = req3dTransactionId
        end

        #
        # ===要求3Dトランザクションステータスを取得する
        # @return:: 要求3Dトランザクションステータス
        #
        def req3d_transaction_status
            @req3d_transaction_status
        end

        #
        # ===要求3Dトランザクションステータスを設定する
        # @param :: req3dTransactionStatus 要求3Dトランザクションステータス
        #
        def req3d_transaction_status=(req3dTransactionStatus)
            @req3d_transaction_status = req3dTransactionStatus
        end

        #
        # ===要求3D CAVVアルゴリズムを取得する
        # @return:: 要求3D CAVVアルゴリズム
        #
        def req3d_cavv_algorithm
            @req3d_cavv_algorithm
        end

        #
        # ===要求3D CAVVアルゴリズムを設定する
        # @param :: req3dCavvAlgorithm 要求3D CAVVアルゴリズム
        #
        def req3d_cavv_algorithm=(req3dCavvAlgorithm)
            @req3d_cavv_algorithm = req3dCavvAlgorithm
        end

        #
        # ===要求3D CAVVを取得する
        # @return:: 要求3D CAVV
        #
        def req3d_cavv
            @req3d_cavv
        end

        #
        # ===要求3D CAVVを設定する
        # @param :: req3dCavv 要求3D CAVV
        #
        def req3d_cavv=(req3dCavv)
            @req3d_cavv = req3dCavv
        end

        #
        # ===要求3D ECIを取得する
        # @return:: 要求3D ECI
        #
        def req3d_eci
            @req3d_eci
        end

        #
        # ===要求3D ECIを設定する
        # @param :: req3dEci 要求3D ECI
        #
        def req3d_eci=(req3dEci)
            @req3d_eci = req3dEci
        end

        #
        # ===要求セキュリティコードを取得する
        # @return:: 要求セキュリティコード
        #
        def req_security_code
            @req_security_code
        end

        #
        # ===要求セキュリティコードを設定する
        # @param :: reqSecurityCode 要求セキュリティコード
        #
        def req_security_code=(reqSecurityCode)
            @req_security_code = reqSecurityCode
        end

        #
        # ===要求認証番号を取得する
        # @return:: 要求認証番号
        #
        def req_auth_flag
            @req_auth_flag
        end

        #
        # ===要求認証番号を設定する
        # @param :: reqAuthFlag 要求認証番号
        #
        def req_auth_flag=(reqAuthFlag)
            @req_auth_flag = reqAuthFlag
        end

        #
        # ===要求誕生日を取得する
        # @return:: 要求誕生日
        #
        def req_birthday
            @req_birthday
        end

        #
        # ===要求誕生日を設定する
        # @param :: reqBirthday 要求誕生日
        #
        def req_birthday=(reqBirthday)
            @req_birthday = reqBirthday
        end

        #
        # ===要求電話番号を取得する
        # @return:: 要求電話番号
        #
        def req_tel
            @req_tel
        end

        #
        # ===要求電話番号を設定する
        # @param :: reqTel 要求電話番号
        #
        def req_tel=(reqTel)
            @req_tel = reqTel
        end

        #
        # ===要求カナ名前（名）を取得する
        # @return:: 要求カナ名前（名）
        #
        def req_first_kana_name
            @req_first_kana_name
        end

        #
        # ===要求カナ名前（名）を設定する
        # @param :: reqFirstKanaName 要求カナ名前（名）
        #
        def req_first_kana_name=(reqFirstKanaName)
            @req_first_kana_name = reqFirstKanaName
        end

        #
        # ===要求カナ名前（姓）を取得する
        # @return:: 要求カナ名前（姓）
        #
        def req_last_kana_name
            @req_last_kana_name
        end

        #
        # ===要求カナ名前（姓）を設定する
        # @param :: reqLastKanaName 要求カナ名前（姓）
        #
        def req_last_kana_name=(reqLastKanaName)
            @req_last_kana_name = reqLastKanaName
        end

        #
        # ===応答マーチャントトランザクション番号を取得する
        # @return:: 応答マーチャントトランザクション番号
        #
        def res_merchant_transaction
            @res_merchant_transaction
        end

        #
        # ===応答マーチャントトランザクション番号を設定する
        # @param :: resMerchantTransaction 応答マーチャントトランザクション番号
        #
        def res_merchant_transaction=(resMerchantTransaction)
            @res_merchant_transaction = resMerchantTransaction
        end

        #
        # ===応答リターン参照番号を取得する
        # @return:: 応答リターン参照番号
        #
        def res_return_reference_number
            @res_return_reference_number
        end

        #
        # ===応答リターン参照番号を設定する
        # @param :: resReturnReferenceNumber 応答リターン参照番号
        #
        def res_return_reference_number=(resReturnReferenceNumber)
            @res_return_reference_number = resReturnReferenceNumber
        end

        #
        # ===応答承認番号を取得する
        # @return:: 応答承認番号
        #
        def res_auth_code
            @res_auth_code
        end

        #
        # ===応答承認番号を設定する
        # @param :: resAuthCode 応答承認番号
        #
        def res_auth_code=(resAuthCode)
            @res_auth_code = resAuthCode
        end

        #
        # ===アクションコードを取得する
        # @return:: アクションコード
        #
        def res_action_code
            @res_action_code
        end

        #
        # ===アクションコードを設定する
        # @param :: resActionCode アクションコード
        #
        def res_action_code=(resActionCode)
            @res_action_code = resActionCode
        end

        #
        # ===応答センターエラーコードを取得する
        # @return:: 応答センターエラーコード
        #
        def res_center_error_code
            @res_center_error_code
        end

        #
        # ===応答センターエラーコードを設定する
        # @param :: resCenterErrorCode 応答センターエラーコード
        #
        def res_center_error_code=(resCenterErrorCode)
            @res_center_error_code = resCenterErrorCode
        end

        #
        # ===応答与信期間を取得する
        # @return:: 応答与信期間
        #
        def res_auth_term
            @res_auth_term
        end

        #
        # ===応答与信期間を設定する
        # @param :: resAuthTerm 応答与信期間
        #
        def res_auth_term=(resAuthTerm)
            @res_auth_term = resAuthTerm
        end

        #
        # ===応答商品コードを取得する
        # @return:: 応答商品コード
        #
        def res_item_code
            @res_item_code
        end

        #
        # ===応答商品コードを設定する
        # @param :: resItemCode 応答商品コード
        #
        def res_item_code=(resItemCode)
            @res_item_code = resItemCode
        end

        #
        # ===応答データを取得する
        # @return:: 応答データ
        #
        def res_response_data
            @res_response_data
        end

        #
        # ===応答データを設定する
        # @param :: resResponseData 応答データ
        #
        def res_response_data=(resResponseData)
            @res_response_data = resResponseData
        end

        #
        # ===要求通貨単位を取得する
        # @return:: 要求通貨単位
        #
        def req_currency_unit
            @req_currency_unit
        end

        #
        # ===要求通貨単位を設定する
        # @param :: reqCurrencyUnit 要求通貨単位
        #
        def req_currency_unit=(reqCurrencyUnit)
            @req_currency_unit = reqCurrencyUnit
        end

        #
        # ===要求新規返品を取得する
        # @return:: 要求新規返品
        #
        def req_with_new
            @req_with_new
        end

        #
        # ===要求新規返品を設定する
        # @param :: reqWithNew 要求新規返品
        #
        def req_with_new=(reqWithNew)
            @req_with_new = reqWithNew
        end

        #
        # ===仕向け先コードを取得する
        # @return:: 仕向け先コード
        #
        def acquirer_code
            @acquirer_code
        end

        #
        # ===仕向け先コードを設定する
        # @param :: acquirerCode 仕向け先コード
        #
        def acquirer_code=(acquirerCode)
            @acquirer_code = acquirerCode
        end

        #
        # ===結果XML(マスク済み)を設定する
        # @param :: resultXml 結果XML(マスク済み)
        #
        def _set_result_xml=(resultXml)
            @result_xml = resultXml
        end

        #
        # ===結果XML(マスク済み)を取得する
        # @return:: 結果XML(マスク済み)
        #
        def to_string
            @result_xml
        end


        #
        # ===レスポンスのXMLから引数のElementの内容を取得します
        #
        # @param:: XMLのルートから検索対象のエレメントを示す文字列
        #   例"/GWPaymentResponseDto/result/VResultCode"
        # @return:: エレメントが一致して内容があった場合は、その内容の文字列
        #   一致するエレメントが無い場合は、nil
        #
        def get_element(query)
          return nil if @result_xml == nil or @result_xml.size < 1
          return nil if query == nil or query.size < 1

          require "rexml/document"
          doc = REXML::Document.new @result_xml

          doc.elements[query].nil? ? nil : doc.elements[query].get_text.to_s
        end

         #
         # ===レスポンスのXMLからTradURLを取得します
         #
         # @return:: レスポンスのXMLに含まれていた広告用（Trad）URL
         #   エレメントが無いか、エレメントに内容が無ければnullを返す
         # @throws:: RuntimeException
         #
        def get_trad_url
          get_element(TRAD_URL_XPATH)
        end

      end
    end
  end
end
