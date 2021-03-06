# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：カード、コマンド名：決済取消の要求Dtoクラス
      #
      # @author:: Created automatically by EXCEL macro
      #
      class CardCancelRequestDto < ::RequestBaseDto

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
        # - 指定なしの場合：全額取消となります。
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
        # - "mpi"： 指定できません
        # - "house"：
        # - "elio"： 指定できません
        # - ※ 指定が無い場合は、デフォルトのカードオプション
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
        # - "jcn""： Jcn接続
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
        # ===新規フラグを取得する
        # @return:: 新規フラグ
        #
        def with_new
            @with_new
        end

        #
        # ===新規フラグを設定する
        # - 新規フラグを指定します。（任意指定）
        # - "true"： 新規返品
        # - "false"： 取消・返品
        # - ※ 指定が無い場合は、false
        # @param :: withNew 新規フラグ
        #
        def with_new=(withNew)
            @with_new = withNew
        end

        #
        # ===直接返品フラグを取得する
        # @return:: 直接返品フラグ
        #
        def with_direct
            @with_direct
        end

        #
        # ===直接返品フラグを設定する
        # - 直接返品フラグを指定します。（任意指定）
        # - "true"： 直接返品
        # - "false"： 取消・返品
        # - ※ 指定が無い場合は、false
        # - ※ 新規フラグ（withNew）が、"true"の時は、直接返品フラグ（withDirect）に"true"を指定できません。
        # @param :: withDirect 直接返品フラグ
        #
        def with_direct=(withDirect)
            @with_direct = withDirect
        end

        #
        # ===取消日を取得する
        # @return:: 取消日
        #
        def cancel_day
            @cancel_day
        end

        #
        # ===取消日を設定する
        # - 取消日を指定します。
        # - YYYYMMDD の形式
        # - 例） "20090905"
        # @param :: cancelDay 取消日
        #
        def cancel_day=(cancelDay)
            @cancel_day = cancelDay
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
        # - 商品コードを指定します。
        # - ※ 指定が無い場合は、デフォルトの商品コード
        # @param :: itemCode 商品コード
        #
        def item_code=(itemCode)
            @item_code = itemCode
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
        # - 通貨単位を設定します。サポートは"jpy"のみです。
        # - 新規返品フラグがfalseの場合は設定されているとエラーになります
        # @param :: currencyUnit 通貨単位
        #
        def currency_unit=(currencyUnit)
            @currency_unit = currencyUnit
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
