# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/option_params'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =Trad拡張パラメータセット
      #
      # @author:: t.honma
      #
      class TradRequestDto < ::OptionParams

        def initialize
          @option_name = "trad"
        end

        #
        # ===拡張パラメータ名を取得する
        #
        # @return:: 拡張パラメータ名
        #
        def option_name
          @option_name
        end

        #
        # ===文字コードを取得する
        #
        # @return:: 広告サイズコード
        #
        def charset_code
          @charset_code
        end

        #
        # ===文字コードを設定する
        #
        # @param:: charsetCode 文字コード
        #
        def charset_code=(charsetCode)
            @charset_code = charsetCode
        end

        #
        # ===広告サイズコードを取得する
        #
        # @return:: 広告サイズコード
        #
        def scale_code
          @scale_code
        end

        #
        # ===広告サイズコードを設定する
        #
        # @param:: scaleCode 広告サイズコード
        #
        def scale_code=(scaleCode)
          @scale_code = scaleCode
        end

      end
    end
  end
end