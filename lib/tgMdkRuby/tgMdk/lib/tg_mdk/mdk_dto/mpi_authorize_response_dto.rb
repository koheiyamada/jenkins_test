# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/response_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      # 
      # =決済サービスタイプ：3Dセキュアカード連携、コマンド名：申込の応答Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class MpiAuthorizeResponseDto < ::ResponseBaseDto

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
        # - マーチャント側で取引を一意に表す注文管理ID
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
        # ===MPIトランザクションタイプを取得する 
        # @return:: MPIトランザクションタイプ 
        #
        def mpi_transactiontype 
            @mpi_transactiontype
        end

        #
        # ===MPIトランザクションタイプを設定する 
        # @param :: mpiTransactiontype MPIトランザクションタイプ 
        #
        def mpi_transactiontype=(mpiTransactiontype) 
            @mpi_transactiontype = mpiTransactiontype
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
        # ===リダイレクションURIを取得する 
        # @return:: リダイレクションURI 
        #
        def req_redirection_uri 
            @req_redirection_uri
        end

        #
        # ===リダイレクションURIを設定する 
        # @param :: reqRedirectionUri リダイレクションURI 
        #
        def req_redirection_uri=(reqRedirectionUri) 
            @req_redirection_uri = reqRedirectionUri
        end

        #
        # ===要求HTTPユーザエージェントを取得する 
        # @return:: 要求HTTPユーザエージェント 
        #
        def req_http_user_agent 
            @req_http_user_agent
        end

        #
        # ===要求HTTPユーザエージェントを設定する 
        # @param :: reqHttpUserAgent 要求HTTPユーザエージェント 
        #
        def req_http_user_agent=(reqHttpUserAgent) 
            @req_http_user_agent = reqHttpUserAgent
        end

        #
        # ===要求HTTPアセプトを取得する 
        # @return:: 要求HTTPアセプト 
        #
        def req_http_accept 
            @req_http_accept
        end

        #
        # ===要求HTTPアセプトを設定する 
        # @param :: reqHttpAccept 要求HTTPアセプト 
        #
        def req_http_accept=(reqHttpAccept) 
            @req_http_accept = reqHttpAccept
        end

        #
        # ===応答コンテンツを取得する 
        # - 本人認証が成功した場合に
        # - マーチャント側でコンシューマに対して応答するレスポンスです。
        # @return:: 応答コンテンツ 
        #
        def res_response_contents 
            @res_response_contents
        end

        #
        # ===応答コンテンツを設定する 
        # @param :: resResponseContents 応答コンテンツ 
        #
        def res_response_contents=(resResponseContents) 
            @res_response_contents = resResponseContents
        end

        #
        # ===応答会社IDを取得する 
        # @return:: 応答会社ID 
        #
        def res_corporation_id 
            @res_corporation_id
        end

        #
        # ===応答会社IDを設定する 
        # @param :: resCorporationId 応答会社ID 
        #
        def res_corporation_id=(resCorporationId) 
            @res_corporation_id = resCorporationId
        end

        #
        # ===応答ブランドIDを取得する 
        # @return:: 応答ブランドID 
        #
        def res_brand_id 
            @res_brand_id
        end

        #
        # ===応答ブランドIDを設定する 
        # @param :: resBrandId 応答ブランドID 
        #
        def res_brand_id=(resBrandId) 
            @res_brand_id = resBrandId
        end

        #
        # ===応答3Dセキュアメッセージバージョンを取得する 
        # @return:: 応答3Dセキュアメッセージバージョン 
        #
        def res3d_message_version 
            @res3d_message_version
        end

        #
        # ===応答3Dセキュアメッセージバージョンを設定する 
        # @param :: res3dMessageVersion 応答3Dセキュアメッセージバージョン 
        #
        def res3d_message_version=(res3dMessageVersion) 
            @res3d_message_version = res3dMessageVersion
        end

        #
        # ===本人認証要求日時を取得する 
        # @return:: 本人認証要求日時 
        #
        def auth_request_datetime 
            @auth_request_datetime
        end

        #
        # ===本人認証要求日時を設定する 
        # @param :: authRequestDatetime 本人認証要求日時 
        #
        def auth_request_datetime=(authRequestDatetime) 
            @auth_request_datetime = authRequestDatetime
        end

        #
        # ===本人認証応答日時を取得する 
        # @return:: 本人認証応答日時 
        #
        def auth_response_datetime 
            @auth_response_datetime
        end

        #
        # ===本人認証応答日時を設定する 
        # @param :: authResponseDatetime 本人認証応答日時 
        #
        def auth_response_datetime=(authResponseDatetime) 
            @auth_response_datetime = authResponseDatetime
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
