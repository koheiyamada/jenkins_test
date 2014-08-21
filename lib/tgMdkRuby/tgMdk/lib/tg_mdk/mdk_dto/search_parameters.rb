# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:検索条件パラメータ群を保持するクラス
      #
      # @author:: t.honma
      #
      class SearchParameters

        #
        # ===共通検索パラメータを取得する
        #
        # @return:: 共通検索パラメータ
        #
        def common
             @common
        end

        #
        # ===共通検索パラメータを設定する
        #
        # @param:: common 共通検索パラメータ
        #
        def common=(common)
            @common = common
        end

        #
        # ===カード検索パラメータを取得する
        #
        # @return:: カード検索パラメータ
        #
        def card
             @card
        end

        #
        # ===カード検索パラメータを設定する
        #
        # @param:: card カード検索パラメータ
        #
        def card=(card)
            @card = card
        end

        #
        # ===電子マネー検索パラメータを取得する
        #
        # @return:: 電子マネー検索パラメータ
        #
        def em
             @em
        end

        #
        # ===電子マネー検索パラメータを設定する
        #
        # @param:: em 電子マネー検索パラメータ
        #
        def em=(em)
            @em = em
        end

        #
        # ===コンビニ検索パラメータを取得する
        #
        # @return:: コンビニ検索パラメータ
        #
        def cvs
             @cvs
        end

        #
        # ===コンビニ検索パラメータを設定する
        #
        # @param:: cvs コンビニ検索パラメータ
        #
        def cvs=(cvs)
            @cvs = cvs
        end

        #
        # ===ペイジー検索パラメータを取得する
        #
        # @return:: ペイジー検索パラメータ
        #
        def bank
             @bank
        end

        #
        # ===銀行決済検索パラメータを設定する
        #
        # @param:: bank 銀行決済検索パラメータ
        #
        def bank=(bank)
            @bank = bank
        end

        #
        # ===ペイパル検索パラメータを取得する
        #
        # @return:: ペイパル検索パラメータ
        #
        def paypal
             @paypal
        end

        #
        # ===ペイパル検索パラメータを設定する
        #
        # @param:: paypal ペイパル検索パラメータ
        #
        def paypal=(paypal)
            @paypal = paypal
        end

        #
        # ===3Dセキュアカード連携検索パラメータを取得する
        #
        # @return:: 3Dセキュアカード連携検索パラメータ
        #
        def mpi
             @mpi
        end

        #
        # ===3Dセキュアカード連携検索パラメータを設定する
        #
        # @param:: mpi 3Dセキュアカード連携検索パラメータ
        #
        def mpi=(mpi)
            @mpi = mpi
        end

        #
        # ===セゾン検索パラメータを取得する
        #
        # @return:: セゾン検索パラメータ
        #
        def saison
             @saison
        end

        #
        # ===セゾン検索パラメータを設定する
        #
        # @param:: saison セゾン検索パラメータ
        #
        def saison=(saison)
            @saison = saison
        end

        #
        # ===金融機関マスタ検索パラメータを取得する
        #
        # @return:: 金融機関マスタ検索パラメータ
        #
        def bank_financial_inst_info
             @bank_financial_inst_info
        end

        #
        # ===金融機関マスタ検索パラメータを設定する
        #
        # @param:: mpi 金融機関マスタ検索パラメータ
        #
        def bank_financial_inst_info=(bankFinancialInstInfo)
            @bank_financial_inst_info = bankFinancialInstInfo
        end

      end
    end
  end
end
