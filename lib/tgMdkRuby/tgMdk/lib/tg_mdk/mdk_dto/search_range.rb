# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:範囲指定クラス
      #
      # @author:: t.honma
      #
      class SearchRange
        
        #
        # 検索範囲:Fromを取得する
        #
        # @return:: 検索範囲:From
        #
        def from
             @from
        end

        #
        # 検索範囲:Fromを設定する
        #
        # @param:: from 検索範囲:From
        #
        def from=(from)
            @from =  from
        end

        #
        # 検索範囲:Toを取得する
        #
        # @return:: 検索範囲:To
        #
        def to
             @to
        end

        #
        # 検索範囲:Toを設定する
        #
        # @param:: to 検索範囲:To
        #
        def to=(to)
            @to = to
        end

      end
    end
  end
end