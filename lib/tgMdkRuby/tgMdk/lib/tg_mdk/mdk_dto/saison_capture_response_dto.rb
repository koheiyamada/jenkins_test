# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/response_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：Saison決済請求応答電文DTOクラス<br>
      #
      # @author Created automatically by DtoCreator
      #
      class SaisonCaptureResponseDto < ::ResponseBaseDto


        #
        # ===処理後永久不滅ウォレット残高を設定する
        # @param :: aqf_point_balance 処理後永久不滅ウォレット残高
        #
        def aqf_point_balance=(aqf_point_balance)
            @aqf_point_balance = aqf_point_balance
        end

        #
        # ===処理後永久不滅ウォレット残高を取得する
        # @return:: 処理後永久不滅ウォレット残高
        #
        def aqf_point_balance
            @aqf_point_balance
        end

        #
        # ===決済サービスタイプを設定する
        # @param :: service_type 決済サービスタイプ
        #
        def service_type=(service_type)
            @service_type = service_type
        end

        #
        # ===決済サービスタイプを取得する
        # @return:: 決済サービスタイプ
        #
        def service_type
            @service_type
        end

        #
        # ===処理結果コードを設定する
        # @param :: mstatus 処理結果コード
        #
        def mstatus=(mstatus)
            @mstatus = mstatus
        end

        #
        # ===処理結果コードを取得する
        # @return:: 処理結果コード
        #
        def mstatus
            @mstatus
        end

        #
        # ===詳細結果コードを設定する
        # @param :: v_result_code 詳細結果コード
        #
        def v_result_code=(v_result_code)
            @v_result_code = v_result_code
        end

        #
        # ===詳細結果コードを取得する
        # @return:: 詳細結果コード
        #
        def v_result_code
            @v_result_code
        end

        #
        # ===エラーメッセージを設定する
        # @param :: merr_msg エラーメッセージ
        #
        def merr_msg=(merr_msg)
            @merr_msg = merr_msg
        end

        #
        # ===エラーメッセージを取得する
        # @return:: エラーメッセージ
        #
        def merr_msg
            @merr_msg
        end

        #
        # ===電文IDを設定する
        # @param :: march_txn 電文ID
        #
        def march_txn=(march_txn)
            @march_txn = march_txn
        end

        #
        # ===電文IDを取得する
        # @return:: 電文ID
        #
        def march_txn
            @march_txn
        end

        #
        # ===取引IDを設定する
        # @param :: order_id 取引ID
        #
        def order_id=(order_id)
            @order_id = order_id
        end

        #
        # ===取引IDを取得する
        # @return:: 取引ID
        #
        def order_id
            @order_id
        end

        #
        # ===取引毎に付くIDを設定する
        # @param :: cust_txn 取引毎に付くID
        #
        def cust_txn=(cust_txn)
            @cust_txn = cust_txn
        end

        #
        # ===取引毎に付くIDを取得する
        # @return:: 取引毎に付くID
        #
        def cust_txn
            @cust_txn
        end

        #
        # ===MDK バージョンを設定する
        # @param :: txn_version MDK バージョン
        #
        def txn_version=(txn_version)
            @txn_version = txn_version
        end

        #
        # ===MDK バージョンを取得する
        # @return:: MDK バージョン
        #
        def txn_version
            @txn_version
        end

        #
        # ===カード決済種別を設定する
        # @param :: card_kind カード決済種別
        #
        def card_kind=(card_kind)
            @card_kind = card_kind
        end

        #
        # ===カード決済種別を取得する
        # @return:: カード決済種別
        #
        def card_kind
            @card_kind
        end

        #
        # ===決済サービスタイプ（カード決済）を設定する
        # @param :: card_service_type 決済サービスタイプ（カード決済）
        #
        def card_service_type=(card_service_type)
            @card_service_type = card_service_type
        end

        #
        # ===決済サービスタイプ（カード決済）を取得する
        # @return:: 決済サービスタイプ（カード決済）
        #
        def card_service_type
            @card_service_type
        end

        #
        # ===処理結果コード（カード決済）を設定する
        # @param :: card_mstatus 処理結果コード（カード決済）
        #
        def card_mstatus=(card_mstatus)
            @card_mstatus = card_mstatus
        end

        #
        # ===処理結果コード（カード決済）を取得する
        # @return:: 処理結果コード（カード決済）
        #
        def card_mstatus
            @card_mstatus
        end

        #
        # ===詳細結果コード（カード決済）を設定する
        # @param :: card_v_result_code 詳細結果コード（カード決済）
        #
        def card_v_result_code=(card_v_result_code)
            @card_v_result_code = card_v_result_code
        end

        #
        # ===詳細結果コード（カード決済）を取得する
        # @return:: 詳細結果コード（カード決済）
        #
        def card_v_result_code
            @card_v_result_code
        end

        #
        # ===エラーメッセージ（カード決済）を設定する
        # @param :: card_merr_msg エラーメッセージ（カード決済）
        #
        def card_merr_msg=(card_merr_msg)
            @card_merr_msg = card_merr_msg
        end

        #
        # ===エラーメッセージ（カード決済）を取得する
        # @return:: エラーメッセージ（カード決済）
        #
        def card_merr_msg
            @card_merr_msg
        end

        #
        # ===電文ID（カード決済）を設定する
        # @param :: card_march_txn 電文ID（カード決済）
        #
        def card_march_txn=(card_march_txn)
            @card_march_txn = card_march_txn
        end

        #
        # ===電文ID（カード決済）を取得する
        # @return:: 電文ID（カード決済）
        #
        def card_march_txn
            @card_march_txn
        end

        #
        # ===取引ID（カード決済）を設定する
        # @param :: card_order_id 取引ID（カード決済）
        #
        def card_order_id=(card_order_id)
            @card_order_id = card_order_id
        end

        #
        # ===取引ID（カード決済）を取得する
        # @return:: 取引ID（カード決済）
        #
        def card_order_id
            @card_order_id
        end

        #
        # ===取引毎に付くID（カード決済）を設定する
        # @param :: card_cust_txn 取引毎に付くID（カード決済）
        #
        def card_cust_txn=(card_cust_txn)
            @card_cust_txn = card_cust_txn
        end

        #
        # ===取引毎に付くID（カード決済）を取得する
        # @return:: 取引毎に付くID（カード決済）
        #
        def card_cust_txn
            @card_cust_txn
        end

        #
        # ===MDK バージョン（カード決済）を設定する
        # @param :: card_txn_version MDK バージョン（カード決済）
        #
        def card_txn_version=(card_txn_version)
            @card_txn_version = card_txn_version
        end

        #
        # ===MDK バージョン（カード決済）を取得する
        # @return:: MDK バージョン（カード決済）
        #
        def card_txn_version
            @card_txn_version
        end

        #
        # ===カードトランザクションタイプを設定する
        # @param :: card_transactiontype カードトランザクションタイプ
        #
        def card_transactiontype=(card_transactiontype)
            @card_transactiontype = card_transactiontype
        end

        #
        # ===カードトランザクションタイプを取得する
        # @return:: カードトランザクションタイプ
        #
        def card_transactiontype
            @card_transactiontype
        end

        #
        # ===ゲートウェイ要求日時を設定する
        # @param :: gateway_request_date ゲートウェイ要求日時
        #
        def gateway_request_date=(gateway_request_date)
            @gateway_request_date = gateway_request_date
        end

        #
        # ===ゲートウェイ要求日時を取得する
        # @return:: ゲートウェイ要求日時
        #
        def gateway_request_date
            @gateway_request_date
        end

        #
        # ===ゲートウェイ応答日時を設定する
        # @param :: gateway_response_date ゲートウェイ応答日時
        #
        def gateway_response_date=(gateway_response_date)
            @gateway_response_date = gateway_response_date
        end

        #
        # ===ゲートウェイ応答日時を取得する
        # @return:: ゲートウェイ応答日時
        #
        def gateway_response_date
            @gateway_response_date
        end

        #
        # ===センター要求日時を設定する
        # @param :: center_request_date センター要求日時
        #
        def center_request_date=(center_request_date)
            @center_request_date = center_request_date
        end

        #
        # ===センター要求日時を取得する
        # @return:: センター要求日時
        #
        def center_request_date
            @center_request_date
        end

        #
        # ===センター応答日時を設定する
        # @param :: center_response_date センター応答日時
        #
        def center_response_date=(center_response_date)
            @center_response_date = center_response_date
        end

        #
        # ===センター応答日時を取得する
        # @return:: センター応答日時
        #
        def center_response_date
            @center_response_date
        end

        #
        # ===ペンディングを設定する
        # @param :: pending ペンディング
        #
        def pending=(pending)
            @pending = pending
        end

        #
        # ===ペンディングを取得する
        # @return:: ペンディング
        #
        def pending
            @pending
        end

        #
        # ===ループバックを設定する
        # @param :: loopback ループバック
        #
        def loopback=(loopback)
            @loopback = loopback
        end

        #
        # ===ループバックを取得する
        # @return:: ループバック
        #
        def loopback
            @loopback
        end

        #
        # ===接続先カード接続センターを設定する
        # @param :: connected_center_id 接続先カード接続センター
        #
        def connected_center_id=(connected_center_id)
            @connected_center_id = connected_center_id
        end

        #
        # ===接続先カード接続センターを取得する
        # @return:: 接続先カード接続センター
        #
        def connected_center_id
            @connected_center_id
        end

        #
        # ===センター要求番号を設定する
        # @param :: center_request_number センター要求番号
        #
        def center_request_number=(center_request_number)
            @center_request_number = center_request_number
        end

        #
        # ===センター要求番号を取得する
        # @return:: センター要求番号
        #
        def center_request_number
            @center_request_number
        end

        #
        # ===センターリファレンス番号を設定する
        # @param :: center_reference_number センターリファレンス番号
        #
        def center_reference_number=(center_reference_number)
            @center_reference_number = center_reference_number
        end

        #
        # ===センターリファレンス番号を取得する
        # @return:: センターリファレンス番号
        #
        def center_reference_number
            @center_reference_number
        end

        #
        # ===要求カード番号を設定する
        # @param :: req_card_number 要求カード番号
        #
        def req_card_number=(req_card_number)
            @req_card_number = req_card_number
        end

        #
        # ===要求カード番号を取得する
        # @return:: 要求カード番号
        #
        def req_card_number
            @req_card_number
        end

        #
        # ===要求カード有効期限を設定する
        # @param :: req_card_expire 要求カード有効期限
        #
        def req_card_expire=(req_card_expire)
            @req_card_expire = req_card_expire
        end

        #
        # ===要求カード有効期限を取得する
        # @return:: 要求カード有効期限
        #
        def req_card_expire
            @req_card_expire
        end

        #
        # ===要求カードオプションタイプを設定する
        # @param :: req_card_option_type 要求カードオプションタイプ
        #
        def req_card_option_type=(req_card_option_type)
            @req_card_option_type = req_card_option_type
        end

        #
        # ===要求カードオプションタイプを取得する
        # @return:: 要求カードオプションタイプ
        #
        def req_card_option_type
            @req_card_option_type
        end

        #
        # ===要求取引金額を設定する
        # @param :: req_amount 要求取引金額
        #
        def req_amount=(req_amount)
            @req_amount = req_amount
        end

        #
        # ===要求取引金額を取得する
        # @return:: 要求取引金額
        #
        def req_amount
            @req_amount
        end

        #
        # ===要求マーチャントトランザクション番号を設定する
        # @param :: req_merchant_transaction 要求マーチャントトランザクション番号
        #
        def req_merchant_transaction=(req_merchant_transaction)
            @req_merchant_transaction = req_merchant_transaction
        end

        #
        # ===要求マーチャントトランザクション番号を取得する
        # @return:: 要求マーチャントトランザクション番号
        #
        def req_merchant_transaction
            @req_merchant_transaction
        end

        #
        # ===要求リターン参照番号を設定する
        # @param :: req_return_reference_number 要求リターン参照番号
        #
        def req_return_reference_number=(req_return_reference_number)
            @req_return_reference_number = req_return_reference_number
        end

        #
        # ===要求リターン参照番号を取得する
        # @return:: 要求リターン参照番号
        #
        def req_return_reference_number
            @req_return_reference_number
        end

        #
        # ===要求承認番号を設定する
        # @param :: req_auth_code 要求承認番号
        #
        def req_auth_code=(req_auth_code)
            @req_auth_code = req_auth_code
        end

        #
        # ===要求承認番号を取得する
        # @return:: 要求承認番号
        #
        def req_auth_code
            @req_auth_code
        end

        #
        # ===要求仕向け先コードを設定する
        # @param :: req_acquirer_code 要求仕向け先コード
        #
        def req_acquirer_code=(req_acquirer_code)
            @req_acquirer_code = req_acquirer_code
        end

        #
        # ===要求仕向け先コードを取得する
        # @return:: 要求仕向け先コード
        #
        def req_acquirer_code
            @req_acquirer_code
        end

        #
        # ===要求商品コードを設定する
        # @param :: req_item_code 要求商品コード
        #
        def req_item_code=(req_item_code)
            @req_item_code = req_item_code
        end

        #
        # ===要求商品コードを取得する
        # @return:: 要求商品コード
        #
        def req_item_code
            @req_item_code
        end

        #
        # ===要求カードセンターを設定する
        # @param :: req_card_center 要求カードセンター
        #
        def req_card_center=(req_card_center)
            @req_card_center = req_card_center
        end

        #
        # ===要求カードセンターを取得する
        # @return:: 要求カードセンター
        #
        def req_card_center
            @req_card_center
        end

        #
        # ===要求支払種別情報を設定する
        # @param :: req_jpo_information 要求支払種別情報
        #
        def req_jpo_information=(req_jpo_information)
            @req_jpo_information = req_jpo_information
        end

        #
        # ===要求支払種別情報を取得する
        # @return:: 要求支払種別情報
        #
        def req_jpo_information
            @req_jpo_information
        end

        #
        # ===要求売上日を設定する
        # @param :: req_sales_day 要求売上日
        #
        def req_sales_day=(req_sales_day)
            @req_sales_day = req_sales_day
        end

        #
        # ===要求売上日を取得する
        # @return:: 要求売上日
        #
        def req_sales_day
            @req_sales_day
        end

        #
        # ===要求取消日を設定する
        # @param :: req_cancel_day 要求取消日
        #
        def req_cancel_day=(req_cancel_day)
            @req_cancel_day = req_cancel_day
        end

        #
        # ===要求取消日を取得する
        # @return:: 要求取消日
        #
        def req_cancel_day
            @req_cancel_day
        end

        #
        # ===要求同時売上を設定する
        # @param :: req_with_capture 要求同時売上
        #
        def req_with_capture=(req_with_capture)
            @req_with_capture = req_with_capture
        end

        #
        # ===要求同時売上を取得する
        # @return:: 要求同時売上
        #
        def req_with_capture
            @req_with_capture
        end

        #
        # ===要求同時直接を設定する
        # @param :: req_with_direct 要求同時直接
        #
        def req_with_direct=(req_with_direct)
            @req_with_direct = req_with_direct
        end

        #
        # ===要求同時直接を取得する
        # @return:: 要求同時直接
        #
        def req_with_direct
            @req_with_direct
        end

        #
        # ===要求セキュリティコードを設定する
        # @param :: req_security_code 要求セキュリティコード
        #
        def req_security_code=(req_security_code)
            @req_security_code = req_security_code
        end

        #
        # ===要求セキュリティコードを取得する
        # @return:: 要求セキュリティコード
        #
        def req_security_code
            @req_security_code
        end

        #
        # ===要求認証番号を設定する
        # @param :: req_auth_flag 要求認証番号
        #
        def req_auth_flag=(req_auth_flag)
            @req_auth_flag = req_auth_flag
        end

        #
        # ===要求認証番号を取得する
        # @return:: 要求認証番号
        #
        def req_auth_flag
            @req_auth_flag
        end

        #
        # ===要求誕生日を設定する
        # @param :: req_birthday 要求誕生日
        #
        def req_birthday=(req_birthday)
            @req_birthday = req_birthday
        end

        #
        # ===要求誕生日を取得する
        # @return:: 要求誕生日
        #
        def req_birthday
            @req_birthday
        end

        #
        # ===要求電話番号を設定する
        # @param :: req_tel 要求電話番号
        #
        def req_tel=(req_tel)
            @req_tel = req_tel
        end

        #
        # ===要求電話番号を取得する
        # @return:: 要求電話番号
        #
        def req_tel
            @req_tel
        end

        #
        # ===要求カナ名前（名）を設定する
        # @param :: req_first_kana_name 要求カナ名前（名）
        #
        def req_first_kana_name=(req_first_kana_name)
            @req_first_kana_name = req_first_kana_name
        end

        #
        # ===要求カナ名前（名）を取得する
        # @return:: 要求カナ名前（名）
        #
        def req_first_kana_name
            @req_first_kana_name
        end

        #
        # ===要求カナ名前（姓）を設定する
        # @param :: req_last_kana_name 要求カナ名前（姓）
        #
        def req_last_kana_name=(req_last_kana_name)
            @req_last_kana_name = req_last_kana_name
        end

        #
        # ===要求カナ名前（姓）を取得する
        # @return:: 要求カナ名前（姓）
        #
        def req_last_kana_name
            @req_last_kana_name
        end

        #
        # ===応答マーチャントトランザクション番号を設定する
        # @param :: res_merchant_transaction 応答マーチャントトランザクション番号
        #
        def res_merchant_transaction=(res_merchant_transaction)
            @res_merchant_transaction = res_merchant_transaction
        end

        #
        # ===応答マーチャントトランザクション番号を取得する
        # @return:: 応答マーチャントトランザクション番号
        #
        def res_merchant_transaction
            @res_merchant_transaction
        end

        #
        # ===応答リターン参照番号を設定する
        # @param :: res_return_reference_number 応答リターン参照番号
        #
        def res_return_reference_number=(res_return_reference_number)
            @res_return_reference_number = res_return_reference_number
        end

        #
        # ===応答リターン参照番号を取得する
        # @return:: 応答リターン参照番号
        #
        def res_return_reference_number
            @res_return_reference_number
        end

        #
        # ===応答承認番号を設定する
        # @param :: res_auth_code 応答承認番号
        #
        def res_auth_code=(res_auth_code)
            @res_auth_code = res_auth_code
        end

        #
        # ===応答承認番号を取得する
        # @return:: 応答承認番号
        #
        def res_auth_code
            @res_auth_code
        end

        #
        # ===アクションコードを設定する
        # @param :: res_action_code アクションコード
        #
        def res_action_code=(res_action_code)
            @res_action_code = res_action_code
        end

        #
        # ===アクションコードを取得する
        # @return:: アクションコード
        #
        def res_action_code
            @res_action_code
        end

        #
        # ===応答センターエラーコードを設定する
        # @param :: res_center_error_code 応答センターエラーコード
        #
        def res_center_error_code=(res_center_error_code)
            @res_center_error_code = res_center_error_code
        end

        #
        # ===応答センターエラーコードを取得する
        # @return:: 応答センターエラーコード
        #
        def res_center_error_code
            @res_center_error_code
        end

        #
        # ===応答商品コードを設定する
        # @param :: res_item_code 応答商品コード
        #
        def res_item_code=(res_item_code)
            @res_item_code = res_item_code
        end

        #
        # ===応答商品コードを取得する
        # @return:: 応答商品コード
        #
        def res_item_code
            @res_item_code
        end

        #
        # ===応答データを設定する
        # @param :: res_response_data 応答データ
        #
        def res_response_data=(res_response_data)
            @res_response_data = res_response_data
        end

        #
        # ===応答データを取得する
        # @return:: 応答データ
        #
        def res_response_data
            @res_response_data
        end

        #
        # ===要求通貨単位を設定する
        # @param :: req_currency_unit 要求通貨単位
        #
        def req_currency_unit=(req_currency_unit)
            @req_currency_unit = req_currency_unit
        end

        #
        # ===要求通貨単位を取得する
        # @return:: 要求通貨単位
        #
        def req_currency_unit
            @req_currency_unit
        end

        #
        # ===要求新規返品を設定する
        # @param :: req_with_new 要求新規返品
        #
        def req_with_new=(req_with_new)
            @req_with_new = req_with_new
        end

        #
        # ===要求新規返品を取得する
        # @return:: 要求新規返品
        #
        def req_with_new
            @req_with_new
        end

        #
        # ===仕向け先コードを設定する
        # @param :: acquirer_code 仕向け先コード
        #
        def acquirer_code=(acquirer_code)
            @acquirer_code = acquirer_code
        end

        #
        # ===仕向け先コードを取得する
        # @return:: 仕向け先コード
        #
        def acquirer_code
            @acquirer_code
        end

        #
        # ===trAd広告ＵＲＬ(カード決済用)を設定する
        # @param :: card_trad_url trAd広告ＵＲＬ(カード決済用)
        #
        def card_trad_url=(card_trad_url)
            @card_trad_url = card_trad_url
        end

        #
        # ===trAd広告ＵＲＬ(カード決済用)を取得する
        # @return:: trAd広告ＵＲＬ(カード決済用)
        #
        def card_trad_url
            @card_trad_url
        end




        #
        # ===trAd用の詳細結果コードを取得する
        # @return:: trAd用の詳細結果コード
        #
        def get_trad_v_result_code
            saison_url = get_element(TRAD_URL_XPATH)
            card_url = card_trad_url

            # SaisonのtradUrlがある場合はSaisonの詳細結果コードを返す
            return @v_result_code if saison_url != nil and 0 < saison_url.size

            # SaisonのtradUrlが無く、カードのtradUrlがある場合はSaisonの詳細結果コードを返す
            return @card_v_result_code if card_url != nil and 0 < card_url.size

            @v_result_code
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
            # SaisonのtradUrlを取得
            url = get_element(TRAD_URL_XPATH)

            # SaisonのtradUrlが無い場合はカードのtradUrlを取得
            url = card_trad_url.to_s if url.nil? or url.size < 1

            url
        end

      end
    end
  end
end
