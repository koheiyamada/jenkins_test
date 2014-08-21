# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      
      # 
      # =決済サービスタイプ：電子マネー、コマンド名：プレゼント請求の要求Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class EmGiveRequestDto < ::RequestBaseDto

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
        SERVICE_COMMAND = "Give";

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
        # - マーチャント側でプレゼント請求処理を一意に表す注文管理ID
        # - 申込処理ごとに一意である必要があります。
        # - 半角英数字、“-”（ハイフン）、“_”（アンダースコア）も使用可能です。
        # - ※Suicaに限り40桁を上限とする。
        # @param :: orderId 取引ID 
        #
        def order_id=(orderId) 
            @order_id = orderId
        end

        #
        # ===金額を取得する 
        # @return:: 金額 
        #
        def amount 
            @amount
        end

        #
        # ===金額を設定する 
        # - プレゼント請求金額となります。
        # - 決済金額以下を指定する必要があります。
        # - 例）1800
        # @param :: amount 金額 
        #
        def amount=(amount) 
            @amount = amount
        end

        #
        # ===決済期限を取得する 
        # @return:: 決済期限 
        #
        def settlement_limit 
            @settlement_limit
        end

        #
        # ===決済期限を設定する 
        # - プレゼントの受取期限となります。
        # - YYYYMMDDhhmmssの形式
        # - 例）20060901235959
        # @param :: settlementLimit 決済期限 
        #
        def settlement_limit=(settlementLimit) 
            @settlement_limit = settlementLimit
        end

        #
        # ===メールアドレスを取得する 
        # @return:: メールアドレス 
        #
        def mail_addr 
            @mail_addr
        end

        #
        # ===メールアドレスを設定する 
        # - プレゼント依頼メールを送信する消費者の携帯電話メールアドレス
        # - となります。
        # @param :: mailAddr メールアドレス 
        #
        def mail_addr=(mailAddr) 
            @mail_addr = mailAddr
        end

        #
        # ===転送メール送信要否を取得する 
        # @return:: 転送メール送信要否 
        #
        def forward_mail_flag 
            @forward_mail_flag
        end

        #
        # ===転送メール送信要否を設定する 
        # - プレゼント依頼メールのコピーメール又はBCCメールをマーチャントメールアドレス（merchantMailAddr）に送信するか否かを設定します。
        # - 0：送信不要
        # - 1：送信要
        # @param :: forwardMailFlag 転送メール送信要否 
        #
        def forward_mail_flag=(forwardMailFlag) 
            @forward_mail_flag = forwardMailFlag
        end

        #
        # ===マーチャントメールアドレスを取得する 
        # @return:: マーチャントメールアドレス 
        #
        def merchant_mail_addr 
            @merchant_mail_addr
        end

        #
        # ===マーチャントメールアドレスを設定する 
        # - プレゼント依頼メールのコピーメール又はBCC メール先マーチャントメールアドレス。
        # - 以下の文字も使用できます。
        # - “.”(ドット)、“-”(ハイフン)、“_”(アンダースコア)、“@”(アットマーク)
        # @param :: merchantMailAddr マーチャントメールアドレス 
        #
        def merchant_mail_addr=(merchantMailAddr) 
            @merchant_mail_addr = merchantMailAddr
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
        # - プレゼントを利用者に通知するためのメールアドレスを指定します。
        # @param :: cancelMailAddr 取消通知メールアドレス 
        #
        def cancel_mail_addr=(cancelMailAddr) 
            @cancel_mail_addr = cancelMailAddr
        end

        #
        # ===依頼メール付加情報を取得する 
        # @return:: 依頼メール付加情報 
        #
        def request_mail_add_info 
            @request_mail_add_info
        end

        #
        # ===依頼メール付加情報を設定する 
        # - プレゼント依頼メールに追加される文字列（プレゼント情報等）です。
        # @param :: requestMailAddInfo 依頼メール付加情報 
        #
        def request_mail_add_info=(requestMailAddInfo) 
            @request_mail_add_info = requestMailAddInfo
        end

        #
        # ===依頼メール送信要否を取得する 
        # @return:: 依頼メール送信要否 
        #
        def request_mail_flag 
            @request_mail_flag
        end

        #
        # ===依頼メール送信要否を設定する 
        # - Suicaポケット発行メールの送信要否を設定します。
        # - 0： 送信不要
        # - 1： 送信要
        # @param :: requestMailFlag 依頼メール送信要否 
        #
        def request_mail_flag=(requestMailFlag) 
            @request_mail_flag = requestMailFlag
        end

        #
        # ===内容確認画面付加情報を取得する 
        # @return:: 内容確認画面付加情報 
        #
        def confirm_screen_add_info 
            @confirm_screen_add_info
        end

        #
        # ===内容確認画面付加情報を設定する 
        # - 内容確認画面に表示する付加情報を設定します。
        # - モバイルSuicaで決済内容確認画面に表示される文字列
        # @param :: confirmScreenAddInfo 内容確認画面付加情報 
        #
        def confirm_screen_add_info=(confirmScreenAddInfo) 
            @confirm_screen_add_info = confirmScreenAddInfo
        end

        #
        # ===完了画面付加情報を取得する 
        # @return:: 完了画面付加情報 
        #
        def complete_screen_add_info 
            @complete_screen_add_info
        end

        #
        # ===完了画面付加情報を設定する 
        # - 決済完了画面に表示する付加情報を設定します。
        # - モバイルSuicaで決済完了画面に表示される文字列
        # @param :: completeScreenAddInfo 完了画面付加情報 
        #
        def complete_screen_add_info=(completeScreenAddInfo) 
            @complete_screen_add_info = completeScreenAddInfo
        end

        #
        # ===画面タイトルを取得する 
        # @return:: 画面タイトル 
        #
        def screen_title 
            @screen_title
        end

        #
        # ===画面タイトルを設定する 
        # - モバイルSuicaでプレゼント完了画面・プレゼント確認画面等で「商品・サービス名」に表示されます。
        # @param :: screenTitle 画面タイトル 
        #
        def screen_title=(screenTitle) 
            @screen_title = screenTitle
        end

        #
        # ===備考を取得する 
        # @return:: 備考 
        #
        def free 
            @free
        end

        #
        # ===備考を設定する 
        # - 備考(商品詳細など)
        # @param :: free 備考 
        #
        def free=(free) 
            @free = free
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
