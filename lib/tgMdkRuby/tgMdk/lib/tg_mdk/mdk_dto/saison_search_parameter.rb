# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:セゾン検索パラメータクラス
      #
      # @author:: y.kohara
      #
      class SaisonSearchParameter

        #
        # ===詳細オーダー決済状態を取得する
        #
        # @return:: 詳細オーダー決済状態
        #
        def detail_order_type
             @detail_order_type
        end

        #
        # ===詳細オーダー決済状態を設定する
        #
        # @param:: detail_order_type 詳細オーダー決済状態
        #
        def detail_order_type=(detail_order_type)
            @detail_order_type = detail_order_type
        end

        #
        # ===合計決済金額（From, To）を取得する
        #
        # @return:: 合計決済金額（From, To）
        #
        def total_amount
             @total_amount
        end

        #
        # ===合計決済金額（From, To）を設定する
        #
        # @param:: total_amount 合計決済金額（From, To）
        #
        def total_amount=(total_amount)
            @total_amount = total_amount
        end

        #
        # ===ウォレット決済金額（From, To）を取得する
        #
        # @return:: ウォレット決済金額（From, To）
        #
        def wallet_amount
             @wallet_amount
        end

        #
        # ===ウォレット決済金額（From, To）を設定する
        #
        # @param:: wallet_amount ウォレット決済金額（From, To）
        #
        def wallet_amount=(wallet_amount)
            @wallet_amount = wallet_amount
        end

        #
        # ===カード決済金額（From, To）を取得する
        #
        # @return:: カード決済金額（From, To）
        #
        def card_amount
             @card_amount
        end

        #
        # ===カード決済金額（From, To）を設定する
        #
        # @param:: card_amount カード決済金額（From, To）
        #
        def card_amount=(card_amount)
            @card_amount = card_amount
        end

      end
    end
  end
end