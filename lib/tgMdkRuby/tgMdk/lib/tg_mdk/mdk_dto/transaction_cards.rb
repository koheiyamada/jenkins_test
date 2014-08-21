# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索結果:Saisonトランザクションカード情報電文リストのクラス
      #
      # @author:: Created automatically by DtoCreator
      #
      class TransactionCards


        #
        # ===Saisonトランザクションカード情報を取得する
        #
        # @return:: Saisonトランザクションカード情報
        #
        def transaction_card
             @transaction_card
        end

        #
        # ===Saisonトランザクションカード情報を設定する
        #
        # @param:: transaction_card Saisonトランザクションカード情報
        #
        def transaction_card=(transaction_card)
            @transaction_card = transaction_card
        end


      end
    end
  end
end
