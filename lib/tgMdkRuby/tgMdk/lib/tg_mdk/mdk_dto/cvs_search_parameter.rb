# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:コンビニ検索パラメータクラス
      #
      # @author:: t.honma
      #
      class CvsSearchParameter

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
        # ===コンビニタイプを取得する
        #
        # @return:: @コンビニタイプ
        #
        def cvs_type
          @cvs_type
        end

        #
        # ===コンビニタイプを設定する
        #
        # @param:: cvsType コンビニタイプ
        #
        def cvs_type=(cvsType)
          @cvs_type = cvsType
        end

        #
        # ===支払期限（From, To）を取得する
        #
        # @return:: @支払期限（From, To）
        #
        def pay_limit
          @pay_limit
        end

        #
        # ===支払期限（From, To）を設定する
        #
        # @param:: payLimit 支払期限（From, To）
        #
        def pay_limit=(payLimit)
          @pay_limit = payLimit
        end

        #
        # ===入金受付日（From, To）を取得する
        #
        # @return:: @入金受付日（From, To）
        #
        def paid_datetime
          @paid_datetime
        end

        #
        # ===入金受付日（From, To）を設定する
        #
        # @param:: paidDatetime 入金受付日（From, To）
        #
        def paid_datetime=(paidDatetime)
          @paid_datetime = paidDatetime
        end

      end

    end
  end
end