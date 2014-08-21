# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:card検索パラメータクラス
      #
      # @author:: t.honma
      #
      class CardSearchParameter

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
        # @param:: detailOrderType 詳細オーダー決済状態
        #
        def detail_order_type=(detailOrderType)
          @detail_order_type = detailOrderType
        end

        #
        # ===仕向先カード会社を取得する
        #
        # @return:: 仕向先カード会社
        #
        def requested_corporation_id
          @requested_corporation_id
        end

        #
        # ===仕向先カード会社を設定する
        #
        # @param:: requestedCorporationId 仕向先カード会社
        #
        def requested_corporation_id=(requestedCorporationId)
          @requested_corporation_id = requestedCorporationId
        end

        #
        # ===支払い種別を取得する
        #
        # @return:: 支払い種別
        #
        def requested_payment_method_type
          @requested_payment_method_type
        end

        #
        # ===支払い種別を設定する
        #
        # @param:: requestedPaymentMethodType 支払い種別
        #
        def requested_payment_method_type=(requestedPaymentMethodType)
          @requested_payment_method_type = requestedPaymentMethodType
        end

        #
        # ===3d-xidを取得する
        #
        # @return:: 3d-xid
        #
        def ddd_transaction_id
          @ddd_transaction_id
        end

        #
        # ===3d-xidを設定する
        #
        # @param:: dddTransactionId 3d-xid
        #
        def ddd_transaction_id=(dddTransactionId)
          @ddd_transaction_id = dddTransactionId
        end

      end
    end
  end
end
