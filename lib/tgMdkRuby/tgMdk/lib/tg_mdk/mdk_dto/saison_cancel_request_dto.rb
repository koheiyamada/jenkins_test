# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：Saison取消請求要求電文DTOクラス<br>
      #
      # @author:: Created automatically by DtoCreator
      #
      class SaisonCancelRequestDto < ::RequestBaseDto

        #
        # ===コンストラクタ
        #
        def initialize
          @service_type = SERVICE_TYPE
          @service_command = SERVICE_COMMAND
        end


        #
        # 決済サービスタイプ
        # 半角英数字
        # 必須項目、固定値
        #
        SERVICE_TYPE = "saison";

        #
        # 決済サービスコマンド
        # 半角英数字
        # 必須項目、固定値
        #
        SERVICE_COMMAND = "Cancel";


        #
        # ===決済サービスタイプを取得する
        # @return:: 決済サービスタイプ
        #
        def service_type
            @service_type
        end

        #
        # ===決済サービスコマンドを取得する
        # @return:: 決済サービスコマンド
        #
        def service_command
            @service_command
        end

        #
        # ===決済サービスオプションを設定する
        # @param :: service_option_type 決済サービスオプション
        #
        def service_option_type=(service_option_type)
            @service_option_type = service_option_type
        end

        #
        # ===決済サービスオプションを取得する
        # @return:: 決済サービスオプション
        #
        def service_option_type
            @service_option_type
        end

        #
        # ===取引IDを設定する
        # @param :: order_id 取引ID
        #
        def order_id=(order_id)
            @order_id = order_id
        end

        #
        # ===取引IDを取得する
        # @return:: 取引ID
        #
        def order_id
            @order_id
        end

        #
        # ===カード取消フラグを設定する
        # @param :: card_cancel_flag カード取消フラグ
        #
        def card_cancel_flag=(card_cancel_flag)
            @card_cancel_flag = card_cancel_flag
        end

        #
        # ===カード取消フラグを取得する
        # @return:: カード取消フラグ
        #
        def card_cancel_flag
            @card_cancel_flag
        end



        #
        # ===ログ用文字列(マスク済み)を設定する
        # @param :: maskedLog ログ用文字列(マスク済み)
        #
        def _set_masked_log=(maskedLog)
            @masked_log = maskedLog
        end

        #
        # ===ログ用文字列(マスク済み)を取得する
        # @return:: ログ用文字列(マスク済み)
        #
        def to_string
            @masked_log
        end


        #
        # ===拡張パラメータリストを取得する
        # @return:: 拡張パラメータリスト
        #
        def option_params
            @option_params
        end

        #
        # ===拡張パラメータリストを設定する
        # @param:: optionParams 拡張パラメータリスト
        #
        def option_params=(optionParams)
            @option_params = optionParams
        end

      end
    end
  end
end
