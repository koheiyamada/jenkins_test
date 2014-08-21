# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      
      # 
      # =決済サービスタイプ：電子マネー、コマンド名：返金の要求Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class EmRefundRequestDto < ::RequestBaseDto

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
        SERVICE_COMMAND = "Refund";

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
        # - 例） モバイルEdyの場合： "edy-mobile"
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
        # ===金額を取得する 
        # @return:: 金額 
        #
        def amount 
            @amount
        end

        #
        # ===金額を設定する 
        # - 返金金額となります。決済金額以下を指定する必要があります。
        # - 例）1800
        # @param :: amount 金額 
        #
        def amount=(amount) 
            @amount = amount
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
        # - 返金請求オーダーの種別を指定します。
        # @param :: orderKind オーダー種別 
        #
        def order_kind=(orderKind) 
            @order_kind = orderKind
        end

        #
        # ===返金対象取引IDを取得する 
        # @return:: 返金対象取引ID 
        #
        def refund_order_id 
            @refund_order_id
        end

        #
        # ===返金対象取引IDを設定する 
        # - 返金を依頼する決済請求の取引IDを指定します。
        # @param :: refundOrderId 返金対象取引ID 
        #
        def refund_order_id=(refundOrderId) 
            @refund_order_id = refundOrderId
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
        # - 返金・新規返金の受取期限となります。
        # - YYYYMMDDhhmmssの形式
        # - 例）20060901235901
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
        # - 返金・新規返金依頼メールを送信する消費者の携帯電話メールアドレスとなります。
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
        # - 返金・新規返金依頼メールのコピーメール又はBCCメールをマーチャントメールアドレス（merchantMailAddr）に送信するか否かを設定します。
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
        # - 返金・新規返金依頼メールのコピーメール又はBCC メール先マーチャントメールアドレス。
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
        # - 返金・新規返金を利用者に通知するためのメールアドレスを指定します。
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
        # - 返金・新規返金依頼メールに追加される文字列（返金情報等）です。
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
        # - 返金・新規返金完了画面に表示する付加情報を設定します。
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
        # - モバイルSuicaで返金・新規返金完了画面・返金・新規返金確認画面等で「商品・サービス名」に表示されます。
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
        # ===Edy個別ギフト名称を取得する 
        # @return:: Edy個別ギフト名称 
        #
        def edy_gift_name 
            @edy_gift_name
        end

        #
        # ===Edy個別ギフト名称を設定する 
        # - Edyギフト画面で表示されるギフト名称の後に、個別ギフト名称を指定します。
        # @param :: edyGiftName Edy個別ギフト名称 
        #
        def edy_gift_name=(edyGiftName) 
            @edy_gift_name = edyGiftName
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
