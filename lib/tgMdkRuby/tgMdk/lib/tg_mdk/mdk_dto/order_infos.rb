# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索結果:オーダー情報リストのクラス
      #
      # @author:: t.honma
      #
      class OrderInfos

        #
        # ===コンストラクタ
        #
        def initialize
          @order_info = [Veritrans::Tercerog::Mdk::BaseDto.new]
        end

        #
        # ===オーダー情報を取得する
        # @return:: オーダー情報
        #
        def order_info
          @order_info
        end

        #
        # ===オーダー情報を設定する
        # @param::  orderInfo オーダー情報
        #
        def order_info=(orderInfo)
          @order_info = orderInfo
        end

      end
    end
  end
end