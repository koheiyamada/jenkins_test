# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =マスタ情報リストのクラス
      #
      # @author:: t.honma
      #
      class MasterInfos
        
        #
        # ===コンストラクタ
        #
        def initialize
          @master_info = [Veritrans::Tercerog::Mdk::BaseDto.new]
        end

        #
        # ===マスタ情報を取得する
        # @return:: マスタ情報
        #
        def master_info
          @master_info
        end

        #
        # ===マスタ情報を設定する
        # @param::  masterInfo マスタ情報
        #
        def master_info=(masterInfo)
          @master_info = masterInfo
        end
        
      end
    end
  end
end