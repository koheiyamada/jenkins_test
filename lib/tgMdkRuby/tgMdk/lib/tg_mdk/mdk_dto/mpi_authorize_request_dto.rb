# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      
      # 
      # =決済サービスタイプ：3Dセキュアカード連携、コマンド名：申込の要求Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class MpiAuthorizeRequestDto < ::RequestBaseDto

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
        SERVICE_TYPE = "mpi";

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
        # - 決済サービスオプションの区分を指定します。
        # - 必須項目
        # - "mpi-none"：　MPI単体サービス
        # - "mpi-complete"：　完全認証
        # - "mpi-company"：　通常認証（カード会社リスク負担）
        # - "mpi-merchant"：　通常認証（カード会社、加盟店リスク負担）
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
        # - 決済金額を指定します。
        # - 1 以上かつ 99999999 以下である必要があります。
        # @param :: amount 決済金額 
        #
        def amount=(amount) 
            @amount = amount
        end

        #
        # ===カード番号を取得する 
        # @return:: カード番号 
        #
        def card_number 
            @card_number
        end

        #
        # ===カード番号を設定する 
        # - クレジットカード番号を指定します。
        # - 例） クレジットカード番号は19桁まで処理が可能。
        # - （ハイフンを含んでも含まなくても同様に処理が可能）
        # - 戻り値としては､上2桁/下4桁の計6桁が返ります。
        # @param :: cardNumber カード番号 
        #
        def card_number=(cardNumber) 
            @card_number = cardNumber
        end

        #
        # ===カード有効期限を取得する 
        # @return:: カード有効期限 
        #
        def card_expire 
            @card_expire
        end

        #
        # ===カード有効期限を設定する 
        # - クレジットカードの有効期限を指定します。
        # - MM/YY （月 + "/" + 年）の形式
        # - 例） "11/09"
        # @param :: cardExpire カード有効期限 
        #
        def card_expire=(cardExpire) 
            @card_expire = cardExpire
        end

        #
        # ===カード接続センターを取得する 
        # @return:: カード接続センター 
        #
        def card_center 
            @card_center
        end

        #
        # ===カード接続センターを設定する 
        # - カード接続センターを指定します。（任意指定）
        # - "sln"： Sln接続"
        # - "jcn"： Jcn接続
        # - ※ 指定が無い場合は、デフォルトの接続センターを検証
        # @param :: cardCenter カード接続センター 
        #
        def card_center=(cardCenter) 
            @card_center = cardCenter
        end

        #
        # ===仕向け先コードを取得する 
        # @return:: 仕向け先コード 
        #
        def acquirer_code 
            @acquirer_code
        end

        #
        # ===仕向け先コードを設定する 
        # - 仕向け先カード会社コードを指定します。
        # - （店舗が加盟店契約をしているカード会社）
        # - ※ 最終的に決済を行うカード発行会社ではなく、決済要求電文が最初に仕向けられる加盟店管理会社となります。
        # - 01 シティカードジャパン株式会社（ダイナースカード）
        # - 02 株式会社 ジェーシービー 
        # - 03 三菱UFJニコス株式会社（旧DCカード）
        # - 04 三井住友カード株式会社（りそなカード株式会社などVISAジャパングループ）
        # - 05 三菱UFJニコス株式会社（旧UFJカード）
        # - 06 ユーシーカード株式会社
        # - 07 アメリカン・
        # @param :: acquirerCode 仕向け先コード 
        #
        def acquirer_code=(acquirerCode) 
            @acquirer_code = acquirerCode
        end

        #
        # ===JPOを取得する 
        # @return:: JPO 
        #
        def jpo 
            @jpo
        end

        #
        # ===JPOを設定する 
        # - JPOを指定します。（任意指定）
        # - "10"
        # - "21"+"支払詳細"
        # - "22"+"支払詳細"
        # - "23"+"支払詳細"
        # - "24"+"支払詳細"
        # - "25"+"支払詳細"
        # - "31"+"支払詳細"
        # - "32"+"支払詳細"
        # - "33"+"支払詳細"
        # - "34"+"支払詳細"
        # - "61"+"支払詳細"
        # - "62"+"支払詳細"
        # - "63"+"支払詳細"
        # - "69"+"支払詳細"
        # - ※ 指定が無い場合は、デフォルトのJPO（一括払い：パターン"10"）
        # @param :: jpo JPO 
        #
        def jpo=(jpo) 
            @jpo = jpo
        end

        #
        # ===売上フラグを取得する 
        # @return:: 売上フラグ 
        #
        def with_capture 
            @with_capture
        end

        #
        # ===売上フラグを設定する 
        # - 売上フラグを指定します。（任意指定）
        # - "true"： 与信・売上
        # - "false"： 与信のみ
        # - ※ 指定が無い場合は、デフォルトの売上フラグ（与信のみ）
        # @param :: withCapture 売上フラグ 
        #
        def with_capture=(withCapture) 
            @with_capture = withCapture
        end

        #
        # ===売上日を取得する 
        # @return:: 売上日 
        #
        def sales_day 
            @sales_day
        end

        #
        # ===売上日を設定する 
        # - 売上日を指定します。（任意指定）
        # - YYYYMMDD の形式
        # - 例） "20090905"
        # - ※ 指定が無い場合は、売上日（取引日:与信のとき無視）
        # @param :: salesDay 売上日 
        #
        def sales_day=(salesDay) 
            @sales_day = salesDay
        end

        #
        # ===商品コードを取得する 
        # @return:: 商品コード 
        #
        def item_code 
            @item_code
        end

        #
        # ===商品コードを設定する 
        # - 商品コードを指定します。（任意指定）
        # - ※ 指定が無い場合は、デフォルトの商品コード
        # @param :: itemCode 商品コード 
        #
        def item_code=(itemCode) 
            @item_code = itemCode
        end

        #
        # ===セキュリティコードを取得する 
        # @return:: セキュリティコード 
        #
        def security_code 
            @security_code
        end

        #
        # ===セキュリティコードを設定する 
        # - セキュリティコードを指定します。
        # @param :: securityCode セキュリティコード 
        #
        def security_code=(securityCode) 
            @security_code = securityCode
        end

        #
        # ===誕生日を取得する 
        # @return:: 誕生日 
        #
        def birthday 
            @birthday
        end

        #
        # ===誕生日を設定する 
        # - 誕生日 を指定します。
        # - カード接続センターがjcnと設定しているときは利用できません。
        # @param :: birthday 誕生日 
        #
        def birthday=(birthday) 
            @birthday = birthday
        end

        #
        # ===電話番号を取得する 
        # @return:: 電話番号 
        #
        def tel 
            @tel
        end

        #
        # ===電話番号を設定する 
        # - 電話番号 を指定します。
        # - カード接続センターがjcnと設定しているときは利用できません。
        # @param :: tel 電話番号 
        #
        def tel=(tel) 
            @tel = tel
        end

        #
        # ===名前（名）カナを取得する 
        # @return:: 名前（名）カナ 
        #
        def first_kana_name 
            @first_kana_name
        end

        #
        # ===名前（名）カナを設定する 
        # - 名前（名）カナ を指定します。
        # - カード接続センターがjcnと設定しているときは利用できません。
        # @param :: firstKanaName 名前（名）カナ 
        #
        def first_kana_name=(firstKanaName) 
            @first_kana_name = firstKanaName
        end

        #
        # ===名前（姓）カナを取得する 
        # @return:: 名前（姓）カナ 
        #
        def last_kana_name 
            @last_kana_name
        end

        #
        # ===名前（姓）カナを設定する 
        # - 名前（姓）カナ を指定します。
        # - カード接続センターがjcnと設定しているときは利用できません。
        # @param :: lastKanaName 名前（姓）カナ 
        #
        def last_kana_name=(lastKanaName) 
            @last_kana_name = lastKanaName
        end

        #
        # ===通貨単位を取得する 
        # @return:: 通貨単位 
        #
        def currency_unit 
            @currency_unit
        end

        #
        # ===通貨単位を設定する 
        # - "jpy"のみ
        # @param :: currencyUnit 通貨単位 
        #
        def currency_unit=(currencyUnit) 
            @currency_unit = currencyUnit
        end

        #
        # ===リダイレクションURIを取得する 
        # @return:: リダイレクションURI 
        #
        def redirection_uri 
            @redirection_uri
        end

        #
        # ===リダイレクションURIを設定する 
        # - 検証結果を返すURIを指定します。指定がない場合には予め登録されたURIを用います。
        # @param :: redirectionUri リダイレクションURI 
        #
        def redirection_uri=(redirectionUri) 
            @redirection_uri = redirectionUri
        end

        #
        # ===HTTPユーザエージェントを取得する 
        # @return:: HTTPユーザエージェント 
        #
        def http_user_agent 
            @http_user_agent
        end

        #
        # ===HTTPユーザエージェントを設定する 
        # - コンシューマのブラウザ情報でアプリケーションサーバから取得して設定します。
        # @param :: httpUserAgent HTTPユーザエージェント 
        #
        def http_user_agent=(httpUserAgent) 
            @http_user_agent = httpUserAgent
        end

        #
        # ===HTTPアセプトを取得する 
        # @return:: HTTPアセプト 
        #
        def http_accept 
            @http_accept
        end

        #
        # ===HTTPアセプトを設定する 
        # - コンシューマのブラウザ情報でアプリケーションサーバから取得して設定します。
        # @param :: httpAccept HTTPアセプト 
        #
        def http_accept=(httpAccept) 
            @http_accept = httpAccept
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
