# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/response_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      # 
      # =決済サービスタイプ：Paypal、コマンド名：与信の応答Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class PaypalAuthorizeResponseDto < ::ResponseBaseDto

        #
        # ===決済サービスタイプを取得する 
        # - 決済サービスの区分を指定します。
        # - 必須項目、固定値
        # - "paypal"： PayPal決済
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
        # - 取消請求処理後、応答電文に含まれる値。
        # - 以下の処理結果のいずれかが格納される
        # - ・success：正常終了
        # - ・failure：異常終了
        # - ・pending：保留状態
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
        # - 結果コード
        # - 例) L001000100000000
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
        # - エラーメッセージ
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
        # - 返金を行った取引IDが格納されます。
        # - “.”（ドット）、“-”（ハイフン）、“_”（アンダースコア）も使用できます。
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
        # ===ログインURLを取得する 
        # - PayPalログイン画面のURLが格納されます。
        # @return:: ログインURL 
        #
        def login_url 
            @login_url
        end

        #
        # ===ログインURLを設定する 
        # @param :: loginUrl ログインURL 
        #
        def login_url=(loginUrl) 
            @login_url = loginUrl
        end

        #
        # ===トークンを取得する 
        # - トークンが格納されます。
        # @return:: トークン 
        #
        def token 
            @token
        end

        #
        # ===トークンを設定する 
        # @param :: token トークン 
        #
        def token=(token) 
            @token = token
        end

        #
        # ===請求番号を取得する 
        # - 3GPSGWが発番するオーダー単位でユニークとなるIDが格納されます。
        # @return:: 請求番号 
        #
        def invoice_id 
            @invoice_id
        end

        #
        # ===請求番号を設定する 
        # @param :: invoiceId 請求番号 
        #
        def invoice_id=(invoiceId) 
            @invoice_id = invoiceId
        end

        #
        # ===顧客番号を取得する 
        # - 顧客番号が格納されます。
        # @return:: 顧客番号 
        #
        def payer_id 
            @payer_id
        end

        #
        # ===顧客番号を設定する 
        # @param :: payerId 顧客番号 
        #
        def payer_id=(payerId) 
            @payer_id = payerId
        end

        #
        # ===取引金額を取得する 
        # - 取引金額が格納されます。
        # @return:: 取引金額 
        #
        def amount 
            @amount
        end

        #
        # ===取引金額を設定する 
        # @param :: amount 取引金額 
        #
        def amount=(amount) 
            @amount = amount
        end

        #
        # ===手数料を取得する 
        # - 手数料が格納されます。
        # @return:: 手数料 
        #
        def fee_amount 
            @fee_amount
        end

        #
        # ===手数料を設定する 
        # @param :: feeAmount 手数料 
        #
        def fee_amount=(feeAmount) 
            @fee_amount = feeAmount
        end

        #
        # ===決済金額を取得する 
        # - 決済金額が格納されます。
        # @return:: 決済金額 
        #
        def settle_amount 
            @settle_amount
        end

        #
        # ===決済金額を設定する 
        # @param :: settleAmount 決済金額 
        #
        def settle_amount=(settleAmount) 
            @settle_amount = settleAmount
        end

        #
        # ===外貨換算レートを取得する 
        # - 外貨換算レートが格納されます。
        # @return:: 外貨換算レート 
        #
        def exchange_rate 
            @exchange_rate
        end

        #
        # ===外貨換算レートを設定する 
        # @param :: exchangeRate 外貨換算レート 
        #
        def exchange_rate=(exchangeRate) 
            @exchange_rate = exchangeRate
        end

        #
        # ===支払時刻を取得する 
        # - 支払時刻が格納されます。
        # - 形式は"yyyyMMddHHmmss"です。
        # @return:: 支払時刻 
        #
        def payment_date 
            @payment_date
        end

        #
        # ===支払時刻を設定する 
        # @param :: paymentDate 支払時刻 
        #
        def payment_date=(paymentDate) 
            @payment_date = paymentDate
        end

        #
        # ===支払ステータスを取得する 
        # - 支払ステータスが格納されます。
        # @return:: 支払ステータス 
        #
        def payment_status 
            @payment_status
        end

        #
        # ===支払ステータスを設定する 
        # @param :: paymentStatus 支払ステータス 
        #
        def payment_status=(paymentStatus) 
            @payment_status = paymentStatus
        end

        #
        # ===決済センタ承認IDを取得する 
        # - PayPalが発番するユニークなIDが格納されます。
        # @return:: 決済センタ承認ID 
        #
        def center_auth_id 
            @center_auth_id
        end

        #
        # ===決済センタ承認IDを設定する 
        # @param :: centerAuthId 決済センタ承認ID 
        #
        def center_auth_id=(centerAuthId) 
            @center_auth_id = centerAuthId
        end

        #
        # ===配送先氏名を取得する 
        # - 配送先氏名が格納されます。
        # @return:: 配送先氏名 
        #
        def ship_name 
            @ship_name
        end

        #
        # ===配送先氏名を設定する 
        # @param :: shipName 配送先氏名 
        #
        def ship_name=(shipName) 
            @ship_name = shipName
        end

        #
        # ===配送先住所１を取得する 
        # - 配送先住所１が格納されます。
        # @return:: 配送先住所１ 
        #
        def ship_street1 
            @ship_street1
        end

        #
        # ===配送先住所１を設定する 
        # @param :: shipStreet1 配送先住所１ 
        #
        def ship_street1=(shipStreet1) 
            @ship_street1 = shipStreet1
        end

        #
        # ===配送先住所２を取得する 
        # - 配送先住所２が格納されます。
        # @return:: 配送先住所２ 
        #
        def ship_street2 
            @ship_street2
        end

        #
        # ===配送先住所２を設定する 
        # @param :: shipStreet2 配送先住所２ 
        #
        def ship_street2=(shipStreet2) 
            @ship_street2 = shipStreet2
        end

        #
        # ===配送先市区町村名を取得する 
        # - 配送先市区町村名が格納されます。
        # @return:: 配送先市区町村名 
        #
        def ship_city 
            @ship_city
        end

        #
        # ===配送先市区町村名を設定する 
        # @param :: shipCity 配送先市区町村名 
        #
        def ship_city=(shipCity) 
            @ship_city = shipCity
        end

        #
        # ===配送先州名を取得する 
        # - 配送先州名が格納されます。
        # @return:: 配送先州名 
        #
        def ship_state 
            @ship_state
        end

        #
        # ===配送先州名を設定する 
        # @param :: shipState 配送先州名 
        #
        def ship_state=(shipState) 
            @ship_state = shipState
        end

        #
        # ===配送先国コードを取得する 
        # - 配送先国コードが格納されます。
        # @return:: 配送先国コード 
        #
        def ship_country 
            @ship_country
        end

        #
        # ===配送先国コードを設定する 
        # @param :: shipCountry 配送先国コード 
        #
        def ship_country=(shipCountry) 
            @ship_country = shipCountry
        end

        #
        # ===配送先郵便番号を取得する 
        # - 配送先郵便番号が格納されます。
        # @return:: 配送先郵便番号 
        #
        def ship_postal_code 
            @ship_postal_code
        end

        #
        # ===配送先郵便番号を設定する 
        # @param :: shipPostalCode 配送先郵便番号 
        #
        def ship_postal_code=(shipPostalCode) 
            @ship_postal_code = shipPostalCode
        end

        #
        # ===配送先電話番号を取得する 
        # - 配送先電話番号が格納されます。
        # @return:: 配送先電話番号 
        #
        def ship_phone 
            @ship_phone
        end

        #
        # ===配送先電話番号を設定する 
        # @param :: shipPhone 配送先電話番号 
        #
        def ship_phone=(shipPhone) 
            @ship_phone = shipPhone
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
