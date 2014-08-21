# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:ペイパル検索パラメータクラス
      #
      # @author:: t.honma
      #
      class PaypalSearchParameter

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
          @detail_order_type  = detailOrderType
        end

        #
        # ===支払日時（From, To）を取得する
        #
        # @return:: 支払日時（From, To）
        #
        def payment_datetime
          @payment_datetime
        end

        #
        # ===支払日時（From, To）を設定する
        #
        # @param:: paymentDatetime 支払日時（From, To）
        #
        def payment_datetime=(paymentDatetime)
          @payment_datetime = paymentDatetime
        end

        #
        # ===請求番号を取得する
        #
        # @return:: 請求番号
        #
        def invoice_id
          @invoice_id
        end

        #
        # ===請求番号を設定する
        #
        # @param:: invoiceId 請求番号
        #
        def invoice_id=(invoiceId)
          @invoice_id = invoiceId
        end

        #
        # ===顧客番号を取得する
        #
        # @return:: 顧客番号
        #
        def payer_id
          @payer_id
        end

        #
        # ===顧客番号を設定する
        #
        # @param:: payerId 顧客番号
        #
        def payer_id=(payerId)
          @payer_id = payerId
        end

      end
    end
  end
end