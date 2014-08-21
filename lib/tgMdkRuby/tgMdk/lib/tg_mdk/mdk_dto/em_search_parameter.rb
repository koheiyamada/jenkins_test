# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:電子マネー検索パラメータクラス
      #
      # @author:: t.honma
      #
      class EmSearchParameter

        #
        # ===詳細オーダー決済状態を取得する
        #
        # @return:: @詳細オーダー決済状態
        #
        def detail_order_type
          @detail_order_type
        end

        #
        # ===詳細オーダー決済状態を設定する
        #
        # @param:: detailOrderType 詳細オーダー決済状態
        #
        def detail_order_type=(detailOrderType)
          @detail_order_type = detailOrderType
        end

        #
        # ===電子マネー種別を取得する
        #
        # @return:: @電子マネー種別
        #
        def em_type
          @em_type
        end

        #
        # ===電子マネー種別を設定する
        #
        # @param:: emType 電子マネー種別
        #
        def em_type=(emType)
          @em_type = emType
        end

        #
        # ===支払い種別を取得する
        #
        # @return:: @支払い種別
        #
        def option_type
          @option_type
        end

        #
        # ===支払い種別を設定する
        #
        # @param:: optionType 支払い種別
        #
        def option_type=(optionType)
          @option_type = optionType
        end

        #
        # ===支払/受取期限（From, To）を取得する
        #
        # @return:: @支払/受取期限（From, To）
        #
        def settlement_limit
          @settlement_limit
        end

        #
        # ===支払/受取期限（From, To）を設定する
        #
        # @param:: settlementLimit 支払/受取期限（From, To）
        #
        def settlement_limit=(settlementLimit)
          @settlement_limit = settlementLimit
        end

        #
        # ===支払完了日時（From, To）を取得する
        #
        # @return:: @支払完了日時（From, To）
        #
        def complete_datetime
          @complete_datetime
        end

        #
        # ===支払完了日時（From, To）を設定する
        #
        # @param:: completeDatetime 支払完了日時（From, To）
        #
        def complete_datetime=(completeDatetime)
          @complete_datetime = completeDatetime
        end

        #
        # ===受付番号を取得する
        #
        # @return:: @受付番号
        #
        def receipt_no
          @receipt_no
        end

        #
        # ===受付番号を設定する
        #
        # @param:: receiptNo 受付番号
        #
        def receipt_no=(receiptNo)
          @receipt_no = receiptNo
        end

      end

    end
  end
end