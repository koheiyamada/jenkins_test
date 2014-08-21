# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索結果:オーダー情報のクラス
      #
      # @author:: t.honma
      #
      class OrderInfo

        #
        # ===コンストラクタ
        #
        def initialize
            @proper_order_info = Veritrans::Tercerog::Mdk::BaseDto.new
            @transaction_infos = Veritrans::Tercerog::Mdk::BaseDto.new
        end

        #
        #
        # ===インデックスを取得する
        #
        # @return:: @インデックス
        #
        def index
          @index
        end

        #
        # ===インデックスを設定する
        #
        # @param:: index インデックス
        #
        def index=(index)
          @index = index
        end

        #
        # ===決済サービスタイプを取得する
        #
        # @return:: @決済サービスタイプ
        #
        def service_type_cd
          @service_type_cd
        end

        #
        # ===決済サービスタイプを設定する
        #
        # @param:: serviceTypeCd 決済サービスタイプ
        #
        def service_type_cd=(serviceTypeCd)
          @service_type_cd = serviceTypeCd
        end

        #
        # ===オーダーIDを取得する
        #
        # @return:: @オーダーID
        #
        def order_id
          @order_id
        end

        #
        # ===オーダーIDを設定する
        #
        # @param:: orderId オーダーID
        #
        def order_id=(orderId)
          @order_id = orderId
        end

        #
        # ===オーダー決済状態を取得する
        #
        # @return:: @オーダー決済状態
        #
        def order_status
          @order_status
        end

        #
        # ===オーダー決済状態を設定する
        #
        # @param:: orderStatus オーダー決済状態
        #
        def order_status=(orderStatus)
          @order_status = orderStatus
        end

        #
        # ===最終成功トランザクションタイプを取得する
        #
        # @return:: @最終成功トランザクションタイプ
        #
        def last_success_txn_type
          @last_success_txn_type
        end

        #
        # ===最終成功トランザクションタイプを設定する
        #
        # @param:: lastSuccessTxnType 最終成功トランザクションタイプ
        #
        def last_success_txn_type=(lastSuccessTxnType)
          @last_success_txn_type = lastSuccessTxnType
        end

        #
        # ===詳細トランザクションタイプを取得する
        #
        # @return:: @詳細トランザクションタイプ
        #
        def success_detail_txn_type
          @success_detail_txn_type
        end

        #
        # ===詳細トランザクションタイプを設定する
        #
        # @param:: successDetailTxnType 詳細トランザクションタイプ
        #
        def success_detail_txn_type=(successDetailTxnType)
          @success_detail_txn_type = successDetailTxnType
        end

        #
        # ===固有オーダー情報を取得する
        #
        # @return:: @固有オーダー情報
        #
        def proper_order_info
          @proper_order_info
        end

        #
        # ===固有オーダー情報を設定する
        #
        # @param:: properOrderInfo 固有オーダー情報
        #
        def proper_order_info=(properOrderInfo)
          @proper_order_info = properOrderInfo
        end

        #
        # ===決済トランザクションリストを取得する
        #
        # @return:: @決済トランザクションリスト
        #
        def transaction_infos
          @transaction_infos
        end

        #
        # ===決済トランザクションリストを設定する
        #
        # @param:: transactioninfos 決済トランザクションリスト
        #
        def transaction_infos=(transactionInfos)
          @transaction_infos = transactionInfos
        end

      end
    end
  end
end