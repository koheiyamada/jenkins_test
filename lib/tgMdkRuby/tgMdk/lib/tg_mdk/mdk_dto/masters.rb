# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =マスタ検索結果のクラス
      #
      # @author:: t.honma
      #
      class Masters

        #
        # ===コンストラクタ
        #
        def initialize
            @bank_financial_inst_info = [Veritrans::Tercerog::Mdk::BaseDto.new]
        end

        #
        # ===金融機関マスタリストを取得する
        # @return:: 金融機関マスタリスト
        #
        def bank_financial_inst_info
          @bank_financial_inst_info
        end

        #
        # ===金融機関マスタリストを設定する
        # @param::  bankFinancialInstInfo 金融機関マスタリスト
        #
        def bank_financial_inst_info=(bankFinancialInstInfo)
          @bank_financial_inst_info = bankFinancialInstInfo
        end
        
      end
    end
  end
end