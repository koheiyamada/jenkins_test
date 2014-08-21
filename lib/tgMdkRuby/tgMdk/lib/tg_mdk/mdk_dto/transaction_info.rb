# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索結果:決済トランザクションのクラス
      #
      # @author:: t.honma
      #
      class TransactionInfo

        #
        # ===コンストラクタ
        #
        def initialize
          @proper_transaction_info = Veritrans::Tercerog::Mdk::BaseDto.new
        end

        #
        # ===トランザクション管理IDを取得する
        #
        # @return:: トランザクション管理ID
        #
        def txn_id
          @txn_id
        end

        #
        # ===トランザクション管理IDを設定する
        #
        # @param:: txnId トランザクション管理ID
        #
        def txn_id=(txnId)
          @txn_id = txnId
        end

        #
        # ===コマンドを取得する
        #
        # @return:: コマンド
        #
        def command
          @command
        end

        #
        # ===コマンドを設定する
        #
        # @param:: command コマンド
        #
        def command=(command)
          @command = command
        end

        #
        # ===ステータスコードを取得する
        #
        # @return:: ステータスコード
        #
        def mstatus
          @mstatus
        end

        #
        # ===ステータスコードを設定する
        #
        # @param:: mstatus ステータスコード
        #
        def mstatus=(mstatus)
          @mstatus = mstatus
        end

        #
        # ===結果コードを取得する
        #
        # @return:: 結果コード
        #
        def v_result_code
          @v_result_code
        end

        #
        # ===結果コードを設定する
        #
        # @param:: vResultCode 結果コード
        #
        def v_result_code=(vResultCode)
          @v_result_code = vResultCode
        end

        #
        # ===取引日時を取得する
        #
        # @return:: 取引日時
        #
        def txn_datetime
          @txn_datetime
        end

        #
        # ===取引日時を設定する
        #
        # @param:: txnDatetime 取引日時
        #
        def txn_datetime=(txnDatetime)
          @txn_datetime = txnDatetime
        end

        #
        # ===金額を取得する
        #
        # @return:: 金額
        #
        def amount
          @amount
        end

        #
        # ===金額を設定する
        #
        # @param:: amount 金額
        #
        def amount=(amount)
          @amount = amount
        end

        #
        # ===固有トランザクション情報を取得する
        #
        # @return:: 固有トランザクション情報
        #
        def proper_transaction_info
          @proper_transaction_info
        end

        #
        # ===固有トランザクション情報を設定する
        #
        # @param:: amount 固有トランザクション情報
        #
        def proper_transaction_info=(properTransactionInfo)
          @proper_transaction_info = properTransactionInfo
        end
        
      end
    end
  end
end