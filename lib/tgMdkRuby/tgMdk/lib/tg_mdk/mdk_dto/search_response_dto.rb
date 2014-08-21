# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/response_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：Search 応答Dtoクラス
      #
      # @author:: t.honma
      #
      class SearchResponseDto < ::ResponseBaseDto

        #
        # ===コンストラクタ
        #
        def initialize
            @order_infos = Veritrans::Tercerog::Mdk::BaseDto.new
            @master_infos = Veritrans::Tercerog::Mdk::BaseDto.new
        end

        #
        # ===決済サービスタイプを取得する
        # @return:: @決済サービスタイプ
        #
        def service_type
             @service_type
        end

        #
        # ===決済サービスタイプを設定する
        # @param:: serviceType 決済サービスタイプ
        #
        def service_type=(serviceType)
            @service_type = serviceType
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
        # @param:: orderId 取引ID
        #
        def order_id=(orderId)
            @order_id = orderId
        end

        #
        # ===処理結果コードを取得する
        # @return:: @処理結果コード
        #
        def mstatus
             @mstatus
        end

        #
        # ===処理結果コードを設定する
        # @param:: mstatus 処理結果コード
        #
        def mstatus=(mstatus)
            @mstatus = mstatus
        end

        #
        # ===詳細結果コードを取得する
        # @return:: @詳細結果コード
        #
        def v_result_code
             @v_result_code
        end

        #
        # ===詳細結果コードを設定する
        # @param:: vResultCode 詳細結果コード
        #
        def v_result_code=(vResultCode)
            @v_result_code = vResultCode
        end

        #
        # ===エラーメッセージを取得する
        # @return:: @エラーメッセージ
        #
        def merr_msg
             @merr_msg
        end

        #
        # ===エラーメッセージを設定する
        # @param:: merrMsg エラーメッセージ
        #
        def merr_msg=(merrMsg)
            @merr_msg = merrMsg
        end

        #
        # ===最大件数超えフラグを取得する
        # @return:: @最大件数超えフラグ
        #
        def over_max_count_flag
             @over_max_count_flag
        end

        #
        # ===最大件数超えフラグを設定する
        # @param:: overMaxCountFlag 最大件数超えフラグ
        #
        def over_max_count_flag=(overMaxCountFlag)
            @over_max_count_flag = overMaxCountFlag
        end

        #
        # ===検索結果件数（オーダー件数）を取得する
        # @return:: @検索結果件数（オーダー件数）
        #
        def search_count
             @search_count
        end

        #
        # ===検索結果件数（オーダー件数）を設定する
        # @param:: searchCount 検索結果件数（オーダー件数）
        #
        def search_count=(searchCount)
            @search_count = searchCount
        end

        #
        # ===電文IDを取得する
        # @return:: @電文ID
        #
        def march_txn
             @march_txn
        end

        #
        # ===電文IDを設定する
        # @param:: marchTxn 電文ID
        #
        def march_txn=(marchTxn)
            @march_txn = marchTxn
        end

        #
        # ===取引毎に付くIDを取得する
        # @return:: @取引毎に付くID
        #
        def cust_txn
             @cust_txn
        end

        #
        # ===取引毎に付くIDを設定する
        # @param:: custTxn 取引毎に付くID
        #
        def cust_txn=(custTxn)
            @cust_txn = custTxn
        end

        #
        # ===MDKバージョンを取得する
        # @return:: @MDKバージョン
        #
        def txn_version
             @txn_version
        end

        #
        # ===MDKバージョンを設定する
        # @param:: txnVersion MDKバージョン
        #
        def txn_version=(txnVersion)
            @txn_version = txnVersion
        end

        #
        # ===オーダー情報リストを取得する
        # @return:: @オーダー情報リスト
        #
        def order_infos
             @order_infos
        end

        #
        # ===オーダー情報リストを設定する
        # @param:: orderInfos オーダー情報リスト
        #
        def order_infos=(orderInfos)
            @order_infos = orderInfos
        end

        #
        # ===マスタ情報リストを取得する
        # @return:: マスタ情報リスト
        #
        def master_infos
             @master_infos
        end

        #
        # ===マスタ情報リストを設定する
        # @param:: masterInfos マスタ情報リスト
        #
        def master_infos=(masterInfos)
            @master_infos = masterInfos
        end
        #
        # ===結果XML(マスク済み)を設定する
        # @param:: resultXml 結果XML(マスク済み)
        #
        def _set_result_xml=(resultXml)
            @result_xml = resultXml
        end

        #
        # ===結果XML(マスク済み)を取得する
        # @return:: @結果XML(マスク済み)
        #
        def to_string
             @result_xml
        end

      end
    end
  end
end
