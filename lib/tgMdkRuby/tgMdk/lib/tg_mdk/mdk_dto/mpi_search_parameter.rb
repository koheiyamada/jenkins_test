# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:3Dセキュアカード連携検索パラメータクラス
      #
      # @author:: t.honma
      #
      class MpiSearchParameter

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
        # ===応答3D ECIを取得する
        #
        # @return:: 応答3D ECI
        #
        def res3d_eci
          @res3d_eci
        end

        #
        # ===応答3D ECIを設定する
        # @param:: res3dEci 応答3D ECI
        #
        def res3d_eci=(res3dEci)
          @res3d_eci = res3dEci
        end

        #
        # ===応答3D トランザクションステータスを取得する
        #
        # @return:: 応答3D トランザクションステータス
        #
        def res3d_transaction_status
          @res3d_transaction_status
        end

        #
        # ===応答3D トランザクションステータスを設定する
        #
        # @param:: res3dTransactionStatus 応答3D トランザクションステータス
        #
        def res3d_transaction_status=(res3dTransactionStatus)
          @res3d_transaction_status = res3dTransactionStatus
        end

        #
        # ===応答3D トランザクションIDを取得する
        #
        # @return:: 応答3D トランザクションID
        #
        def res3d_transaction_id
          @res3d_transaction_id
        end

        #
        # ===応答3D トランザクションIDを設定する
        #
        # @param:: res3dTransactionId 応答3DトランザクションID
        #
        def res3d_transaction_id=(res3dTransactionId)
          @res3d_transaction_id = res3dTransactionId
        end

      end
    end
  end
end