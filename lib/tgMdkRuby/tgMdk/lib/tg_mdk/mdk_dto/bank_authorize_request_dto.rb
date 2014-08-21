# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      
      # 
      # =決済サービスタイプ：銀行決済、コマンド名：決済の要求Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class BankAuthorizeRequestDto < ::RequestBaseDto

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
        SERVICE_TYPE = "bank";

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
        # - "atm"：ATM決済(番号通知方式)
        # - "netbank-pc"：ネットバンク決済(銀行リンク方式：PC)
        # - "netbank-docomo"：ネットバンク決済(銀行リンク方式：docomo)
        # - "netbank-softbank"：ネットバンク決済(銀行リンク方式：SoftBank)
        # - "netbank-au"：ネットバンク決済(銀行リンク方式：au)
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
        # @param :: amount 決済金額 
        #
        def amount=(amount) 
            @amount = amount
        end

        #
        # ===顧客名１を取得する 
        # @return:: 顧客名１ 
        #
        def name1 
            @name1
        end

        #
        # ===顧客名１を設定する 
        # @param :: name1 顧客名１ 
        #
        def name1=(name1) 
            @name1 = name1
        end

        #
        # ===顧客名２を取得する 
        # @return:: 顧客名２ 
        #
        def name2 
            @name2
        end

        #
        # ===顧客名２を設定する 
        # @param :: name2 顧客名２ 
        #
        def name2=(name2) 
            @name2 = name2
        end

        #
        # ===顧客名カナ１を取得する 
        # @return:: 顧客名カナ１ 
        #
        def kana1 
            @kana1
        end

        #
        # ===顧客名カナ１を設定する 
        # - 全角英数カナのみ　※最大20Byte
        # @param :: kana1 顧客名カナ１ 
        #
        def kana1=(kana1) 
            @kana1 = kana1
        end

        #
        # ===顧客名カナ２を取得する 
        # @return:: 顧客名カナ２ 
        #
        def kana2 
            @kana2
        end

        #
        # ===顧客名カナ２を設定する 
        # - 全角英数カナのみ　※最大20Byte
        # @param :: kana2 顧客名カナ２ 
        #
        def kana2=(kana2) 
            @kana2 = kana2
        end

        #
        # ===郵便番号１を取得する 
        # @return:: 郵便番号１ 
        #
        def post1 
            @post1
        end

        #
        # ===郵便番号１を設定する 
        # - 郵便番号上３桁
        # @param :: post1 郵便番号１ 
        #
        def post1=(post1) 
            @post1 = post1
        end

        #
        # ===郵便番号２を取得する 
        # @return:: 郵便番号２ 
        #
        def post2 
            @post2
        end

        #
        # ===郵便番号２を設定する 
        # - 郵便番号下４桁
        # @param :: post2 郵便番号２ 
        #
        def post2=(post2) 
            @post2 = post2
        end

        #
        # ===住所１を取得する 
        # @return:: 住所１ 
        #
        def address1 
            @address1
        end

        #
        # ===住所１を設定する 
        # - ※最大50Byte
        # @param :: address1 住所１ 
        #
        def address1=(address1) 
            @address1 = address1
        end

        #
        # ===住所２を取得する 
        # @return:: 住所２ 
        #
        def address2 
            @address2
        end

        #
        # ===住所２を設定する 
        # - ※最大50Byte
        # @param :: address2 住所２ 
        #
        def address2=(address2) 
            @address2 = address2
        end

        #
        # ===住所３を取得する 
        # @return:: 住所３ 
        #
        def address3 
            @address3
        end

        #
        # ===住所３を設定する 
        # - ※最大100Byte
        # @param :: address3 住所３ 
        #
        def address3=(address3) 
            @address3 = address3
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
        # - ハイフンなし、９桁～１１桁
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
        # - YYYYMMDD
        # @param :: payLimit 支払期限 
        #
        def pay_limit=(payLimit) 
            @pay_limit = payLimit
        end

        #
        # ===成約日を取得する 
        # @return:: 成約日 
        #
        def agreement_date 
            @agreement_date
        end

        #
        # ===成約日を設定する 
        # - YYYYMMDD
        # @param :: agreementDate 成約日 
        #
        def agreement_date=(agreementDate) 
            @agreement_date = agreementDate
        end

        #
        # ===請求内容（漢字）を取得する 
        # @return:: 請求内容（漢字） 
        #
        def contents 
            @contents
        end

        #
        # ===請求内容（漢字）を設定する 
        # - インフォメーションとしてＡＴＭ等に表示　※最大24Byte
        # @param :: contents 請求内容（漢字） 
        #
        def contents=(contents) 
            @contents = contents
        end

        #
        # ===請求内容（カナ）を取得する 
        # @return:: 請求内容（カナ） 
        #
        def contents_kana 
            @contents_kana
        end

        #
        # ===請求内容（カナ）を設定する 
        # - インフォメーションとしてＡＴＭ等に表示　※最大48Byte
        # @param :: contentsKana 請求内容（カナ） 
        #
        def contents_kana=(contentsKana) 
            @contents_kana = contentsKana
        end

        #
        # ===決済機関コードを取得する 
        # @return:: 決済機関コード 
        #
        def pay_csv 
            @pay_csv
        end

        #
        # ===決済機関コードを設定する 
        # - ※「画面言語」を設定した場合は、当項目を設定することはできない。
        # @param :: payCsv 決済機関コード 
        #
        def pay_csv=(payCsv) 
            @pay_csv = payCsv
        end

        #
        # ===画面言語を取得する 
        # @return:: 画面言語 
        #
        def view_locale 
            @view_locale
        end

        #
        # ===画面言語を設定する 
        # - ※「決済機関コード」を設定した場合は、当項目を設定することはできない。
        # @param :: viewLocale 画面言語 
        #
        def view_locale=(viewLocale) 
            @view_locale = viewLocale
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
