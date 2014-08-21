# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:共通検索パラメータクラス
      #
      # @author:: t.honma
      #
      class CommonSearchParameter

        #
        # ===オーダーIDを取得する
        # @return:: @オーダーID
        #
        def order_id
          @order_id
        end

        #
        # ===オーダーIDを設定する
        #
        # "*"によるワイルドカード検索が可能
        #
        # @param:: orderId オーダーID
        #
        def order_id=(orderId)
          @order_id = orderId
        end

        #
        # ===オーダー決済状態を取得する
        # @return:: @オーダー決済状態
        #
        def order_status
          @order_status
        end

        #
        # ===オーダー決済状態を設定する
        # @param:: orderStatus オーダー決済状態
        #
        def order_status=(orderStatus)
          @order_status = orderStatus
        end

        #
        # ===コマンドを取得する
        # @return:: @コマンド
        #
        def command
          @command
        end

        #
        # ===コマンドを設定する
        # @param:: command コマンド
        #
        def command=(command)
          @command = command
        end

        #
        # ===ステータスコードを取得する
        # @return:: @ステータスコード
        #
        def mstatus
          @mstatus
        end

        #
        # ===ステータスコードを設定する
        # @param:: mstatus ステータスコード
        #
        def mstatus=(mstatus)
          @mstatus = mstatus
        end

        #
        # ===取引日時（From, To）を取得する
        # @return:: @取引日時（From, To）
        #
        def txn_datetime
          @txn_datetime
        end

        #
        # ===取引日時（From, To）を設定する
        # @param:: txnDatetime 取引日時（From, To）
        #
        def txn_datetime=(txnDatetime)
          @txn_datetime = txnDatetime
        end

        #
        # ===金額（From, To）を取得する
        # @return:: @金額（From, To）
        #
        def amount
          @amount
        end

        #
        # ===金額（From, To）を設定する
        # @param:: amount 金額（From, To）
        #
        def amount=(amount)
          @amount = amount
        end

      end

    end
  end
end