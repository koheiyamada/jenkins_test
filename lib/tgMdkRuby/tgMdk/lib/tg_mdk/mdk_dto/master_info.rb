# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =マスタ名
      #
      # @author:: t.honma
      #
      class MasterInfo

        #
        # ===コンストラクタ
        #
        def initialize
          @masters = Veritrans::Tercerog::Mdk::BaseDto.new
        end

        #
        # ===マスタ名を取得する
        #
        # @return:: マスタ名
        #
        def name
          @name
        end

        #
        # ===マスタ名を設定する
        #
        # @param:: マスタ名
        #
        def name=(name)
          @name = name
        end

        #
        # ===マスタ情報を取得する
        #
        # @return:: マスタ情報
        #
        def masters
          @masters
        end

        #
        # ===マスタ情報を設定する
        #
        # @param:: マスタ情報
        #
        def masters=(masters)
          @masters = masters
        end

      end

    end
  end
end