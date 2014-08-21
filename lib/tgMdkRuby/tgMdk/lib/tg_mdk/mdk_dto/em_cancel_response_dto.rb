# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/response_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      # 
      # =決済サービスタイプ：電子マネー、コマンド名：取消の応答Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class EmCancelResponseDto < ::ResponseBaseDto

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
        # - 例) E001000100000000
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
        # - 取り消し処理を依頼した注文管理ID
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
        # ===MDKバージョンを取得する 
        # - 電文のバージョン番号。
        # @return:: MDKバージョン 
        #
        def txn_version 
            @txn_version
        end

        #
        # ===MDKバージョンを設定する 
        # @param :: txnVersion MDKバージョン 
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
