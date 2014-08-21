# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      
      # 
      # =決済サービスタイプ：電子マネー、コマンド名：決済の要求Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class EmAuthorizeRequestDto < ::RequestBaseDto

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
        SERVICE_COMMAND = "Authorize";

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
        # - 例）
        # * モバイルEdy： "edy-mobile"
        # * パソリ(PC)： "edy-pc"
        # * モバイルEdyダイレクト： "edy-direct"
        # * Suicaモバイル(メール)： "suica-mobile-mail"
        # * モバイルSuicaアプリ： "suica-mobile-app"
        # * Suicaメール決済(PC)： "suica-pc-mail"
        # * Suica PCアプリ： "suica-pc-app"
        #
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
        # - マーチャント側で取引を一意に表す注文管理IDを指定します。
        # - 申込処理ごとに一意である必要があります。
        # - 半角英数字、“-”（ハイフン）、“_”（アンダースコア）も使用可能です。
        # - ※Suicaに限り40桁を上限とする。
        # @param :: orderId 取引ID 
        #
        def order_id=(orderId) 
            @order_id = orderId
        end

        #
        # ===決済金額を取得する 
        # @return:: 決済金額 
        #
        def amount 
            @amount
        end

        #
        # ===決済金額を設定する 
        # - 支払金額となります。
        # - 例）2100
        # @param :: amount 決済金額 
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
        # - 支払の期限となります。
        # - 支払期限を過ぎた決済については、消費者はアプリ上から確認できます。
        # - YYYYMMDDhhmmss の形式
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
        # - 決済依頼メールを送信する消費者の携帯電話メールアドレスとなります。
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
        # - 決済依頼メール、決済完了メールのコピーメール又はBCC メールをマーチャントメールアドレス（merchantMailAddr）に送信するか否かを設定します。
        # - 0： 送信不要
        # - 1： 送信要
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
        # - 決済依頼メール、決済完了メールのコピーメール又はBCC メール先マーチャントメールアドレス。
        # - 以下の文字も使用できます。
        # - “.”(ドット)、“-”(ハイフン)、“_”(アンダースコア)、“@”(アットマーク)
        # @param :: merchantMailAddr マーチャントメールアドレス 
        #
        def merchant_mail_addr=(merchantMailAddr) 
            @merchant_mail_addr = merchantMailAddr
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
        # - 支払依頼メールに追加される文字列（商品情報等）です。
        # @param :: requestMailAddInfo 依頼メール付加情報 
        #
        def request_mail_add_info=(requestMailAddInfo) 
            @request_mail_add_info = requestMailAddInfo
        end

        #
        # ===完了メール付加情報を取得する 
        # @return:: 完了メール付加情報 
        #
        def complete_mail_add_info 
            @complete_mail_add_info
        end

        #
        # ===完了メール付加情報を設定する 
        # - 決済完了メールに追加される文字列（遷移先URL 等）
        # @param :: completeMailAddInfo 完了メール付加情報 
        #
        def complete_mail_add_info=(completeMailAddInfo) 
            @complete_mail_add_info = completeMailAddInfo
        end

        #
        # ===ショップ名を取得する 
        # @return:: ショップ名 
        #
        def shop_name 
            @shop_name
        end

        #
        # ===ショップ名を設定する 
        # - Edy で使用する店舗名
        # @param :: shopName ショップ名 
        #
        def shop_name=(shopName) 
            @shop_name = shopName
        end

        #
        # ===完了メール送信要否を取得する 
        # @return:: 完了メール送信要否 
        #
        def complete_mail_flag 
            @complete_mail_flag
        end

        #
        # ===完了メール送信要否を設定する 
        # - 決済完了時にメールを送信するか否かを設定します。
        # - 0： 送信不要　1： 送信要
        # @param :: completeMailFlag 完了メール送信要否 
        #
        def complete_mail_flag=(completeMailFlag) 
            @complete_mail_flag = completeMailFlag
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
        # - モバイルSuica で決済内容確認画面に表示される文字列
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
        # - モバイルSuica で決済完了画面に表示される文字列
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
        # - モバイルSuica で決済完了画面・決済確認画面等で「商品・サービス名」に表示されます。
        # @param :: screenTitle 画面タイトル 
        #
        def screen_title=(screenTitle) 
            @screen_title = screenTitle
        end

        #
        # ===決済完了戻り先種別を取得する 
        # @return:: 決済完了戻り先種別 
        #
        def complete_return_kind 
            @complete_return_kind
        end

        #
        # ===決済完了戻り先種別を設定する 
        # - モバイルSuica でアプリ終了時に遷移する先の種別
        # - 1： ローカルメニュー
        # - 2： モバイルSuica アプリを終了し「決済完了戻り先URL」へ遷移
        # @param :: completeReturnKind 決済完了戻り先種別 
        #
        def complete_return_kind=(completeReturnKind) 
            @complete_return_kind = completeReturnKind
        end

        #
        # ===決済完了戻り先URLを取得する 
        # @return:: 決済完了戻り先URL 
        #
        def complete_return_url 
            @complete_return_url
        end

        #
        # ===決済完了戻り先URLを設定する 
        # - モバイルSuicaでアプリ終了時に遷移する先のURL
        # @param :: completeReturnUrl 決済完了戻り先URL 
        #
        def complete_return_url=(completeReturnUrl) 
            @complete_return_url = completeReturnUrl
        end

        #
        # ===決済完了通知URLを取得する 
        # @return:: 決済完了通知URL 
        #
        def complete_notice_url 
            @complete_notice_url
        end

        #
        # ===決済完了通知URLを設定する 
        # - Edy Viewer にて支払いを完了した後に遷移するURL
        # @param :: completeNoticeUrl 決済完了通知URL 
        #
        def complete_notice_url=(completeNoticeUrl) 
            @complete_notice_url = completeNoticeUrl
        end

        #
        # ===販売区分を取得する 
        # @return:: 販売区分 
        #
        def sales_type 
            @sales_type
        end

        #
        # ===販売区分を設定する 
        # - Edy で任意に登録する販売区分
        # - 　1：物販、　2：デジタル
        # @param :: salesType 販売区分 
        #
        def sales_type=(salesType) 
            @sales_type = salesType
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
        # ===成功時URLを取得する 
        # @return:: 成功時URL 
        #
        def success_url 
            @success_url
        end

        #
        # ===成功時URLを設定する 
        # - PaSoRi決済時、決済が成功した場合に遷移されるURL
        # @param :: successUrl 成功時URL 
        #
        def success_url=(successUrl) 
            @success_url = successUrl
        end

        #
        # ===失敗時URLを取得する 
        # @return:: 失敗時URL 
        #
        def failure_url 
            @failure_url
        end

        #
        # ===失敗時URLを設定する 
        # - PaSoRi決済時、決済が失敗した場合に遷移されるURL
        # @param :: failureUrl 失敗時URL 
        #
        def failure_url=(failureUrl) 
            @failure_url = failureUrl
        end

        #
        # ===キャンセルURLを取得する 
        # @return:: キャンセルURL 
        #
        def cancel_url 
            @cancel_url
        end

        #
        # ===キャンセルURLを設定する 
        # - PaSoRi決済時、確認画面等でキャンセルボタンが押された場合に遷移されるURL
        # @param :: cancelUrl キャンセルURL 
        #
        def cancel_url=(cancelUrl) 
            @cancel_url = cancelUrl
        end

        #
        # ===加盟店決済受付時刻を取得する 
        # @return:: 加盟店決済受付時刻 
        #
        def member_store_settle_entry_time 
            @member_store_settle_entry_time
        end

        #
        # ===加盟店決済受付時刻を設定する 
        # - 加盟店側で当該決済を受付た時刻
        # - YYYYMMDDhhmmss の形式
        # - 例）20060901235959
        # @param :: memberStoreSettleEntryTime 加盟店決済受付時刻 
        #
        def member_store_settle_entry_time=(memberStoreSettleEntryTime) 
            @member_store_settle_entry_time = memberStoreSettleEntryTime
        end

        #
        # ===支払取消期限を取得する 
        # @return:: 支払取消期限 
        #
        def cancel_limit 
            @cancel_limit
        end

        #
        # ===支払取消期限を設定する 
        # - 決済後、該当の支払を返金（取消）することができる期限。
        # - YYYYMMDDhhmmss の形式
        # - 例）20060901235959
        # @param :: cancelLimit 支払取消期限 
        #
        def cancel_limit=(cancelLimit) 
            @cancel_limit = cancelLimit
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
