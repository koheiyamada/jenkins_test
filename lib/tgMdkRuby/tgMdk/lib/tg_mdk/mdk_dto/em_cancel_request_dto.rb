# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      
      # 
      # =決済サービスタイプ：電子マネー、コマンド名：取消の要求Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class EmCancelRequestDto < ::RequestBaseDto

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
        SERVICE_TYPE = "em";

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
        # ===決済サービスオプションを取得する 
        # @return:: 決済サービスオプション 
        #
        def service_option_type 
            @service_option_type
        end

        #
        # ===決済サービスオプションを設定する 
        # - 決済サービスのオプションを指定します
        # - 例） モバイル-メール決済の場合： "suica-mobile-mail"
        # @param :: serviceOptionType 決済サービスオプション 
        #
        def service_option_type=(serviceOptionType) 
            @service_option_type = serviceOptionType
        end

        #
        # ===取引IDを取得する 
        # @return:: 取引ID 
        #
        def order_id 
            @order_id
        end

        #
        # ===取引IDを設定する 
        # - 取り消し処理を依頼する、マーチャント側で発番済みの注文管理ID
        # - ※Suicaに限り40桁を上限とする。
        # @param :: orderId 取引ID 
        #
        def order_id=(orderId) 
            @order_id = orderId
        end

        #
        # ===オーダー種別を取得する 
        # @return:: オーダー種別 
        #
        def order_kind 
            @order_kind
        end

        #
        # ===オーダー種別を設定する 
        # - オーダー種別を指定します。
        # @param :: orderKind オーダー種別 
        #
        def order_kind=(orderKind) 
            @order_kind = orderKind
        end

        #
        # ===取消通知メールアドレスを取得する 
        # @return:: 取消通知メールアドレス 
        #
        def cancel_mail_addr 
            @cancel_mail_addr
        end

        #
        # ===取消通知メールアドレスを設定する 
        # - 決済の取消完了を利用者に通知するためのメールアドレスを指定します。
        # @param :: cancelMailAddr 取消通知メールアドレス 
        #
        def cancel_mail_addr=(cancelMailAddr) 
            @cancel_mail_addr = cancelMailAddr
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
            return @option_params
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
