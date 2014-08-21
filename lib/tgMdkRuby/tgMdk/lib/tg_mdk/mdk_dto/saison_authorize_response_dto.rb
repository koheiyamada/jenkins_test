# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/response_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：Saison認可画面表示応答電文DTOクラス<br>
      #
      # @author Created automatically by DtoCreator
      #
      class SaisonAuthorizeResponseDto < ::ResponseBaseDto


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
        # ===応答コンテンツを設定する
        # @param :: res_response_contents 応答コンテンツ
        #
        def res_response_contents=(res_response_contents)
            @res_response_contents = res_response_contents
        end

        #
        # ===応答コンテンツを取得する
        # @return:: 応答コンテンツ
        #
        def res_response_contents
            @res_response_contents
        end

        #
        # ===MDKバージョンを設定する
        # @param :: txn_version MDKバージョン
        #
        def txn_version=(txn_version)
            @txn_version = txn_version
        end

        #
        # ===MDKバージョンを取得する
        # @return:: MDKバージョン
        #
        def txn_version
            @txn_version
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
