# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/response_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      # 
      # =決済サービスタイプ：銀行決済、コマンド名：決済の応答Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class BankAuthorizeResponseDto < ::ResponseBaseDto

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
        # ===リクエストIDを取得する 
        # @return:: リクエストID 
        #
        def request_id 
            @request_id
        end

        #
        # ===リクエストIDを設定する 
        # @param :: requestId リクエストID 
        #
        def request_id=(requestId) 
            @request_id = requestId
        end

        #
        # ===収納機関番号を取得する 
        # @return:: 収納機関番号 
        #
        def shuno_kikan_no 
            @shuno_kikan_no
        end

        #
        # ===収納機関番号を設定する 
        # @param :: shunoKikanNo 収納機関番号 
        #
        def shuno_kikan_no=(shunoKikanNo) 
            @shuno_kikan_no = shunoKikanNo
        end

        #
        # ===お客様番号を取得する 
        # @return:: お客様番号 
        #
        def customer_no 
            @customer_no
        end

        #
        # ===お客様番号を設定する 
        # @param :: customerNo お客様番号 
        #
        def customer_no=(customerNo) 
            @customer_no = customerNo
        end

        #
        # ===確認番号を取得する 
        # @return:: 確認番号 
        #
        def confirm_no 
            @confirm_no
        end

        #
        # ===確認番号を設定する 
        # @param :: confirmNo 確認番号 
        #
        def confirm_no=(confirmNo) 
            @confirm_no = confirmNo
        end

        #
        # ===支払パターンを取得する 
        # @return:: 支払パターン 
        #
        def bill_pattern 
            @bill_pattern
        end

        #
        # ===支払パターンを設定する 
        # @param :: billPattern 支払パターン 
        #
        def bill_pattern=(billPattern) 
            @bill_pattern = billPattern
        end

        #
        # ===支払暗号文字列を取得する 
        # @return:: 支払暗号文字列 
        #
        def bill 
            @bill
        end

        #
        # ===支払暗号文字列を設定する 
        # @param :: bill 支払暗号文字列 
        #
        def bill=(bill) 
            @bill = bill
        end

        #
        # ===URLを取得する 
        # @return:: URL 
        #
        def url 
            @url
        end

        #
        # ===URLを設定する 
        # @param :: url URL 
        #
        def url=(url) 
            @url = url
        end

        #
        # ===画面情報を取得する 
        # @return:: 画面情報 
        #
        def view 
            @view
        end

        #
        # ===画面情報を設定する 
        # @param :: view 画面情報 
        #
        def view=(view) 
            @view = view
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
