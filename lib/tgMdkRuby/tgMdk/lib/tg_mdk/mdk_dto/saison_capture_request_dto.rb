# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：Saison決済請求要求電文DTOクラス<br>
      #
      # @author:: Created automatically by DtoCreator
      #
      class SaisonCaptureRequestDto < ::RequestBaseDto

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
        SERVICE_COMMAND = "Capture";


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
        # ===決済金額を設定する
        # @param :: amount 決済金額
        #
        def amount=(amount)
            @amount = amount
        end

        #
        # ===決済金額を取得する
        # @return:: 決済金額
        #
        def amount
            @amount
        end

        #
        # ===永久不滅ウォレット決済金額を設定する
        # @param :: wallet_amount 永久不滅ウォレット決済金額
        #
        def wallet_amount=(wallet_amount)
            @wallet_amount = wallet_amount
        end

        #
        # ===永久不滅ウォレット決済金額を取得する
        # @return:: 永久不滅ウォレット決済金額
        #
        def wallet_amount
            @wallet_amount
        end

        #
        # ===カード決済金額を設定する
        # @param :: card_amount カード決済金額
        #
        def card_amount=(card_amount)
            @card_amount = card_amount
        end

        #
        # ===カード決済金額を取得する
        # @return:: カード決済金額
        #
        def card_amount
            @card_amount
        end

        #
        # ===カード番号を設定する
        # @param :: card_number カード番号
        #
        def card_number=(card_number)
            @card_number = card_number
        end

        #
        # ===カード番号を取得する
        # @return:: カード番号
        #
        def card_number
            @card_number
        end

        #
        # ===カード有効期限を設定する
        # @param :: card_expire カード有効期限
        #
        def card_expire=(card_expire)
            @card_expire = card_expire
        end

        #
        # ===カード有効期限を取得する
        # @return:: カード有効期限
        #
        def card_expire
            @card_expire
        end

        #
        # ===セキュリティコードを設定する
        # @param :: security_code セキュリティコード
        #
        def security_code=(security_code)
            @security_code = security_code
        end

        #
        # ===セキュリティコードを取得する
        # @return:: セキュリティコード
        #
        def security_code
            @security_code
        end

        #
        # ===カード取引ＩＤを設定する
        # @param :: card_order_id カード取引ＩＤ
        #
        def card_order_id=(card_order_id)
            @card_order_id = card_order_id
        end

        #
        # ===カード取引ＩＤを取得する
        # @return:: カード取引ＩＤ
        #
        def card_order_id
            @card_order_id
        end
        
        #
        #
        # ===カード売上フラグを設定する
        # @param :: with_capture カード売上フラグ
        #
        def with_capture=(with_capture)
            @with_capture = with_capture
        end
        
        #
        #
        # ===カード売上フラグを取得する
        # @return:: カード売上フラグ
        def with_capture
          
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
