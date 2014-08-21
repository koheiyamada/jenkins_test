# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索結果:決済トランザクションリストのクラス
      #
      # @author:: t.honma
      #
      class TransactionInfos

        #
        # コンストラクタ
        #
        def initialize
          @transaction_info = [Veritrans::Tercerog::Mdk::BaseDto.new]
        end
        #
        # 決済トランザクションを取得する
        #
        # @return:: 決済トランザクション
        #
        def transaction_info
          @transaction_info
        end

        #
        # 決済トランザクションを設定する
        #
        # @param:: transactionInfo 決済トランザクション
        #
        def transaction_info=(transactionInfo)
          @transaction_info = transactionInfo
        end

      end
    end
  end
end