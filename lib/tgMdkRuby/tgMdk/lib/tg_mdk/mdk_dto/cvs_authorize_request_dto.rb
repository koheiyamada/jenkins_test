# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      
      # 
      # =決済サービスタイプ：コンビニ決済、コマンド名：決済の要求Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class CvsAuthorizeRequestDto < ::RequestBaseDto

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
        SERVICE_TYPE = "cvs";

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
        # - 例） ファミリーマートの場合： "famima"
        # - セブンイレブン：　"sej"
        # - ファミリーマート：　"famima"
        # - ローソン：　"lawson"
        # - その他：　"other"　
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
        # - マーチャントで任意に採番してください。
        # - 申込処理ごとに付ける必要が御座います。
        # - “.”（ドット）、“-”（ハイフン）、“_”（アンダースコア）も使用できます。
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
        # - 支払金額となります。
        # - 例）2100
        # @param :: amount 金額 
        #
        def amount=(amount) 
            @amount = amount
        end

        #
        # ===氏名１を取得する 
        # @return:: 氏名１ 
        #
        def name1 
            @name1
        end

        #
        # ===氏名１を設定する 
        # - 顧客姓
        # - 例） 山田
        # - ※全角ハイフン、全角スペース、外字は、文字化けする恐れがあります
        # @param :: name1 氏名１ 
        #
        def name1=(name1) 
            @name1 = name1
        end

        #
        # ===氏名２を取得する 
        # @return:: 氏名２ 
        #
        def name2 
            @name2
        end

        #
        # ===氏名２を設定する 
        # - 顧客名
        # - 例） 太郎
        # - ※全角ハイフン、全角スペース、外字は、文字化けする恐れがあります
        # @param :: name2 氏名２ 
        #
        def name2=(name2) 
            @name2 = name2
        end

        #
        # ===カナを取得する 
        # @return:: カナ 
        #
        def kana 
            @kana
        end

        #
        # ===カナを設定する 
        # - 顧客カナ名
        # - 例） ヤマダタロウ
        # - ※ファミリーマートのみ設定できます
        # - ※半角スペースは入力不可です
        # - ※全角ハイフン、全角スペース、外字は、文字化けする恐れがあります
        # @param :: kana カナ 
        #
        def kana=(kana) 
            @kana = kana
        end

        #
        # ===電話番号を取得する 
        # @return:: 電話番号 
        #
        def tel_no 
            @tel_no
        end

        #
        # ===電話番号を設定する 
        # - 顧客電話番号、数字のみ11桁以内、ハイフン含み13桁以内
        # - 例） 0311112222、03-1111-2222、09011112222、090-1111-2222
        # @param :: telNo 電話番号 
        #
        def tel_no=(telNo) 
            @tel_no = telNo
        end

        #
        # ===支払期限を取得する 
        # @return:: 支払期限 
        #
        def pay_limit 
            @pay_limit
        end

        #
        # ===支払期限を設定する 
        # - 支払期限
        # - yyyy/mm/dd の形式
        # - セブンイレブン：　当日～60日後を支払期限に指定可能
        # - ファミリーマート：　当日2日後～60日後を支払期限に指定可能
        # - ローソン：　当日～60日後を支払期限に指定可能
        # - その他：　当日～60日後を支払期限に指定可能
        # - 例） 2009/07/24
        # @param :: payLimit 支払期限 
        #
        def pay_limit=(payLimit) 
            @pay_limit = payLimit
        end

        #
        # ===メールアドレスを取得する 
        # @return:: メールアドレス 
        # DEPRECATED: mail_addr is not used.
        #
        def mail_addr 
            @mail_addr
        end

        #
        # ===メールアドレスを設定する 
        # メールアドレスは非推奨となりました。互換性のために残しています
        # @param :: mailAddr メールアドレス 
        # DEPRECATED: mail_addr is not used.
        #
        def mail_addr=(mailAddr) 
            warn "[DEPRECATION] attribute 'mail_addr' is deprecated."
            @mail_addr = mailAddr
        end

        #
        # ===支払区分を取得する 
        # @return:: 支払区分 
        #
        def payment_type 
            @payment_type
        end

        #
        # ===支払区分を設定する 
        # - 支払区分
        # - ※現在はリザーブパラメータのため無条件に "0" を設定
        # @param :: paymentType 支払区分 
        #
        def payment_type=(paymentType) 
            @payment_type = paymentType
        end

        #
        # ===備考１を取得する 
        # @return:: 備考１ 
        #
        def free1 
            @free1
        end

        #
        # ===備考１を設定する 
        # - 備考欄（商品詳細などに利用する）
        # - セブンイレブン： 使用不可
        # - ファミリーマート： 任意（38バイト）
        # - ローソン： 任意（50バイト）
        # - その他： 任意（32バイト）
        # @param :: free1 備考１ 
        #
        def free1=(free1) 
            @free1 = free1
        end

        #
        # ===備考２を取得する 
        # @return:: 備考２ 
        #
        def free2 
            @free2
        end

        #
        # ===備考２を設定する 
        # - 備考欄（商品詳細などに利用する）
        # - セブンイレブン： 使用不可
        # - ファミリーマート：　任意（38バイト）
        # - ローソン： 使用不可
        # - その他：　任意（32バイト）
        # @param :: free2 備考２ 
        #
        def free2=(free2) 
            @free2 = free2
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
