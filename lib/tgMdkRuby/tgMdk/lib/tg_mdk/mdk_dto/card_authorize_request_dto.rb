# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：カード、コマンド名：申込の要求Dtoクラス
      #
      # @author:: Created automatically by EXCEL macro
      #
      class CardAuthorizeRequestDto < ::RequestBaseDto

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
        SERVICE_TYPE = "card";

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
        # ===カードオプションタイプを取得する
        # @return:: カードオプションタイプ
        #
        def card_option_type
            @card_option_type
        end

        #
        # ===カードオプションタイプを設定する
        # - カードオプションタイプを指定します。
        # - "mpi"：
        # - "house"：
        # - "elio"：
        # - ※ 指定が無い場合は、デフォルトのカードオプション
        # - カードオプションタイプ毎の必須項目については
        # - 「（別紙）パラメータ組み合わせ」を参照ください
        # @param :: cardOptionType カードオプションタイプ
        #
        def card_option_type=(cardOptionType)
            @card_option_type = cardOptionType
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
        # - 07 アメリカン・エキスプレス・インターナショナル
        # - 08 株式会社 ジャックス
        # - 09 三菱UFJニコス株式会社（旧日本信販）
        # - 10 株式会社 オリエントコーポレーション
        # - 11 株式会社 セントラルファイナンス
        # - 12 株式会社　アプラス
        # - 13 株式会社 ライフ
        # - 14 楽天KC株式会社
        # - 17 三菱UFJニコス株式会社（旧協同クレジット）
        # 20 GEコンシューマー・ファイナンス株式会社（ジーシーカード）
        # - 21 株式会社 クレディセゾン
        # - 22 ポケットカード 株式会社
        # - 23 株式会社オーエムシーカード
        # - 24 イオンクレジットサービス株式会社
        # - 28 株式会社 バンクカードサービス
        # - 31 トヨタファイナンス 株式会社
        # - 32 株式会社　JALカード
        # - 36 株式会社クオーク
        # - 37 GEコンシューマー・ファイナンス株式会社（GEカード）
        # - 38 東急カード株式会社（TOPカード）
        # - 40 （株）UCS
        # - 47 （株）ほくせん
        # - 48 （株）ソニーファイナンスインターナショナル
        # - 49 ヤフー（株）
        # - 50 （株）ゆめカード
        # - 51 （株）オークス
        # - 52 東日本旅客鉄道（株）（ビューカード）
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
        # - 支払詳細については「（別紙）支払詳細」を参照ください。
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
        # - ※ 指定が無い場合は、false
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
        # - 売上フラグ（No.11)がfalseの場合は利用できません。
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
        # ===3Dメッセージバージョンを取得する
        # @return:: 3Dメッセージバージョン
        #
        def ddd_message_version
            @ddd_message_version
        end

        #
        # ===3Dメッセージバージョンを設定する
        # - Message Version Numberを指定します。
        # - 例） “1.0.2”
        # @param :: dddMessageVersion 3Dメッセージバージョン
        #
        def ddd_message_version=(dddMessageVersion)
            @ddd_message_version = dddMessageVersion
        end

        #
        # ===3DトランザクションIdを取得する
        # @return:: 3DトランザクションId
        #
        def ddd_transaction_id
            @ddd_transaction_id
        end

        #
        # ===3DトランザクションIdを設定する
        # - Transaction Identifier(XID)を指定します。
        # - 20桁バイナリ値をBase64にて28桁英数字に変換した値を指定します。
        # @param :: dddTransactionId 3DトランザクションId
        #
        def ddd_transaction_id=(dddTransactionId)
            @ddd_transaction_id = dddTransactionId
        end

        #
        # ===3Dトランザクションステータスを取得する
        # @return:: 3Dトランザクションステータス
        #
        def ddd_transaction_status
            @ddd_transaction_status
        end

        #
        # ===3Dトランザクションステータスを設定する
        # - 3Dセキュアトランザクションステータスを指定します。
        # - "Y"：本人認証成功
        # - "N"：本人認証失敗（イシュアまたは会員が原因）
        # - "U"：本人認証失敗（上記以外が原因）
        # - "A"：Attempt（暫定的に本人認証成功）
        # - " ": スペース
        # - ""：値なし
        # @param :: dddTransactionStatus 3Dトランザクションステータス
        #
        def ddd_transaction_status=(dddTransactionStatus)
            @ddd_transaction_status = dddTransactionStatus
        end

        #
        # ===3DCAVVアルゴリズムを取得する
        # @return:: 3DCAVVアルゴリズム
        #
        def ddd_cavv_algorithm
            @ddd_cavv_algorithm
        end

        #
        # ===3DCAVVアルゴリズムを設定する
        # - 3DセキュアCAVVアルゴリズムを指定します。
        # - "0"：HMAC
        # - "1"：CVV
        # - "2"：CVV with ATN
        # - "3"：SPA Algorithm
        # - " ":　スペース
        # - ""：値なし
        # @param :: dddCavvAlgorithm 3DCAVVアルゴリズム
        #
        def ddd_cavv_algorithm=(dddCavvAlgorithm)
            @ddd_cavv_algorithm = dddCavvAlgorithm
        end

        #
        # ===3DCAVVを取得する
        # @return:: 3DCAVV
        #
        def ddd_cavv
            @ddd_cavv
        end

        #
        # ===3DCAVVを設定する
        # - 3DセキュアCAVV を指定します。
        # @param :: dddCavv 3DCAVV
        #
        def ddd_cavv=(dddCavv)
            @ddd_cavv = dddCavv
        end

        #
        # ===3DECIを取得する
        # @return:: 3DECI
        #
        def ddd_eci
            @ddd_eci
        end

        #
        # ===3DECIを設定する
        # - 3Dセキュア　ECI を指定します。
        # - "01"：Attempt（Master Card）
        # - "02"：認証成功（Master Card）
        # - "05"：認証成功（VISA、JCB）
        # - "06"：Attempt（VISA、JCB）または未参加（Master Card、VISA、JCB）
        # - "07"：認証実行不能（Master Card、VISA、JCB）
        # @param :: dddEci 3DECI
        #
        def ddd_eci=(dddEci)
            @ddd_eci = dddEci
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
        # ===認証コード（eLIO）を取得する
        # @return:: 認証コード（eLIO）
        #
        def auth_flag
            @auth_flag
        end

        #
        # ===認証コード（eLIO）を設定する
        # - SLN認証アシストサービス用パラメータ[ 認証コード（eLIO） ]
        # - eLIO決済時に採番されるeLIO認証子を設定します。
        # - カード接続センター(No.7)がjcnと設定しているときは利用できません。
        # - カードオプションタイプ（No.6)がelio以外の場合は利用できません。
        # @param :: authFlag 認証コード（eLIO）
        #
        def auth_flag=(authFlag)
            @auth_flag = authFlag
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
        # - SLN認証アシストサービス用パラメータ[ 誕生日 ]
        # - カード利用者が入力するカード保有者の生月日(MMDD形式）を設定します。
        # - カード接続センター(No.7)がjcnと設定しているときは利用できません。
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
        # - SLN認証アシストサービス用パラメータ[ 電話番号 ]
        # - カード利用者が入力するカード保有者の自宅電話番号下4桁を設定します。
        # - カード接続センター(No.7)がjcnと設定しているときは利用できません。
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
        # - SLN認証アシストサービス用パラメータ[ 名前（名）カナ ]
        # - カード利用者が入力するカード保有者のカナ氏名（名）を設定します。
        # - カード接続センター(No.7)がjcnと設定しているときは利用できません。
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
        # - SLN認証アシストサービス用パラメータ[ 名前（姓）カナ ]
        # - カード利用者が入力するカード保有者のカナ氏名（姓）を設定します。
        # - カード接続センター(No.7)がjcnと設定しているときは利用できません。
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
        # ===PINを取得する
        # @return:: PIN
        #
        def pin
            @pin
        end

        #
        # ===PINを設定する
        # - PINを指定します。（任意指定）
        # @param :: pin PIN
        #
        def pin=(pin)
            @pin = pin
        end

        #
        # ===支払タイプを取得する
        # @return:: 支払タイプ
        #
        def payment_type
            @payment_type
        end

        #
        # ===支払タイプを設定する
        # - 支払タイプを指定します。（任意指定）
        # @param :: payment_type 支払タイプ
        #
        def payment_type=(payment_type)
            @payment_type = payment_type
        end

        #
        # ===JIS Ⅰ第2トラック情報を取得する
        # @return:: JIS Ⅰ第2トラック情報
        #
        def jis1_second_track
            @jis1_second_track
        end

        #
        # ===JIS Ⅰ第2トラック情報を設定する
        # - JIS Ⅰ第2トラック情報を指定します。（任意指定）
        # @param :: jis1_second_track JIS Ⅰ第2トラック情報
        #
        def jis1_second_track=(jis1_second_track)
            @jis1_second_track = jis1_second_track
        end

        #
        # ===JIS Ⅱトラック情報を取得する
        # @return:: JIS Ⅱトラック情報
        #
        def jis2_track
            @jis2_track
        end

        #
        # ===JIS Ⅱトラック情報を設定する
        # - JIS Ⅱトラック情報を指定します。（任意指定）
        # @param :: jis2_track JIS Ⅱトラック情報
        #
        def jis2_track=(jis2_track)
            @jis2_track = jis2_track
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
