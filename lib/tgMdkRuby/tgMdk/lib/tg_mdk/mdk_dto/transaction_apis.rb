# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索結果:SaisonトランザクションAPI情報電文リストのクラス
      #
      # @author:: Created automatically by DtoCreator
      #
      class TransactionApis


        #
        # ===SaisonトランザクションAPI情報を取得する
        #
        # @return:: SaisonトランザクションAPI情報
        #
        def transaction_api
             @transaction_api
        end

        #
        # ===SaisonトランザクションAPI情報を設定する
        #
        # @param:: transaction_api SaisonトランザクションAPI情報
        #
        def transaction_api=(transaction_api)
            @transaction_api = transaction_api
        end


      end
    end
  end
end
