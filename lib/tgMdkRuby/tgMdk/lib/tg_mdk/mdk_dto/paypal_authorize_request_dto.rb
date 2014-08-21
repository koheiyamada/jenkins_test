# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      
      # 
      # =決済サービスタイプ：Paypal、コマンド名：与信の要求Dtoクラス
      # 
      # @author:: Created automatically by EXCEL macro
      # 
      class PaypalAuthorizeRequestDto < ::RequestBaseDto

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
        SERVICE_TYPE = "paypal";

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
        # - 決済請求、予授権完了時に採番した取引IDを指定指定します。
        # - “.”（ドット）、“-”（ハイフン）、“_”（アンダースコア）も使用できます。
        # @param :: orderId 取引ID 
        #
        def order_id=(orderId) 
            @order_id = orderId
        end

        #
        # ===取引金額を取得する 
        # @return:: 取引金額 
        #
        def amount 
            @amount
        end

        #
        # ===取引金額を設定する 
        # - 日本円を設定します。
        # - ただし、$10,000 USD を上限とした金額を設定します。
        # @param :: amount 取引金額 
        #
        def amount=(amount) 
            @amount = amount
        end

        #
        # ===アクションタイプを取得する 
        # @return:: アクションタイプ 
        #
        def action 
            @action
        end

        #
        # ===アクションタイプを設定する 
        # - set: 与信請求処理
        # - get: 与信請求確認処理
        # - do : 与信請求完了処理
        # @param :: action アクションタイプ 
        #
        def action=(action) 
            @action = action
        end

        #
        # ===戻り先URLを取得する 
        # @return:: 戻り先URL 
        #
        def return_url 
            @return_url
        end

        #
        # ===戻り先URLを設定する 
        # - 消費者がPayPal上での操作が完了したときの遷移するマーチャントのURLを設定します。
        # - 半角英数字のほかに、URLとして使用できる文字を使用できます。（"."など）
        # @param :: returnUrl 戻り先URL 
        #
        def return_url=(returnUrl) 
            @return_url = returnUrl
        end

        #
        # ===取消URLを取得する 
        # @return:: 取消URL 
        #
        def cancel_url 
            @cancel_url
        end

        #
        # ===取消URLを設定する 
        # - 消費者がPayPal上で支払いをキャンセルした場合に遷移するマーチャントのURLを設定します。
        # - 半角英数字のほかに、URLとして使用できる文字を使用できます。（"."など）
        # @param :: cancelUrl 取消URL 
        #
        def cancel_url=(cancelUrl) 
            @cancel_url = cancelUrl
        end

        #
        # ===ヘッダーイメージURLを取得する 
        # @return:: ヘッダーイメージURL 
        #
        def header_image_url 
            @header_image_url
        end

        #
        # ===ヘッダーイメージURLを設定する 
        # - PayPal画面のヘッダーに表示する画像のURLを設定します。
        # - 半角英数字のほかに、URLとして使用できる文字を使用できます。（"."など）
        # @param :: headerImageUrl ヘッダーイメージURL 
        #
        def header_image_url=(headerImageUrl) 
            @header_image_url = headerImageUrl
        end

        #
        # ===オーダー説明を取得する 
        # @return:: オーダー説明 
        #
        def order_description 
            @order_description
        end

        #
        # ===オーダー説明を設定する 
        # - 商品の説明を設定します。
        # - ※文字コードは"UTF-8"とします。
        # @param :: orderDescription オーダー説明 
        #
        def order_description=(orderDescription) 
            @order_description = orderDescription
        end

        #
        # ===配送先フラグを取得する 
        # @return:: 配送先フラグ 
        #
        def shipping_flag 
            @shipping_flag
        end

        #
        # ===配送先フラグを設定する 
        # - 配送先情報を有効とするかを設定します。
        # - "0"： 配送先の設定を無効にする。
        # - "1"： 配送先の設定を有効にする。
        # @param :: shippingFlag 配送先フラグ 
        #
        def shipping_flag=(shippingFlag) 
            @shipping_flag = shippingFlag
        end

        #
        # ===配送先氏名を取得する 
        # @return:: 配送先氏名 
        #
        def ship_name 
            @ship_name
        end

        #
        # ===配送先氏名を設定する 
        # - 配送先氏名を設定します。
        # - ※文字コードは"UTF-8"とします。
        # - 配送先フラグに"1"を設定した場合は必須。
        # @param :: shipName 配送先氏名 
        #
        def ship_name=(shipName) 
            @ship_name = shipName
        end

        #
        # ===配送先住所１を取得する 
        # @return:: 配送先住所１ 
        #
        def ship_street1 
            @ship_street1
        end

        #
        # ===配送先住所１を設定する 
        # - 配送先住所１を設定します。
        # - ※文字コードは"UTF-8"とします。
        # - 配送先フラグに"1"を設定した場合は必須。
        # @param :: shipStreet1 配送先住所１ 
        #
        def ship_street1=(shipStreet1) 
            @ship_street1 = shipStreet1
        end

        #
        # ===配送先住所２を取得する 
        # @return:: 配送先住所２ 
        #
        def ship_street2 
            @ship_street2
        end

        #
        # ===配送先住所２を設定する 
        # - 配送先住所２を設定します。
        # - ※文字コードは"UTF-8"とします。
        # @param :: shipStreet2 配送先住所２ 
        #
        def ship_street2=(shipStreet2) 
            @ship_street2 = shipStreet2
        end

        #
        # ===配送先市区町村名を取得する 
        # @return:: 配送先市区町村名 
        #
        def ship_city 
            @ship_city
        end

        #
        # ===配送先市区町村名を設定する 
        # - 配送先市区町村名を設定します。
        # - ※文字コードは"UTF-8"とします。
        # - 配送先フラグに"1"を設定した場合は必須。
        # @param :: shipCity 配送先市区町村名 
        #
        def ship_city=(shipCity) 
            @ship_city = shipCity
        end

        #
        # ===配送先州名を取得する 
        # @return:: 配送先州名 
        #
        def ship_state 
            @ship_state
        end

        #
        # ===配送先州名を設定する 
        # - 配送先州名を設定します。
        # - ※文字コードは"UTF-8"とします。
        # @param :: shipState 配送先州名 
        #
        def ship_state=(shipState) 
            @ship_state = shipState
        end

        #
        # ===配送先国コードを取得する 
        # @return:: 配送先国コード 
        #
        def ship_country 
            @ship_country
        end

        #
        # ===配送先国コードを設定する 
        # - 配送先コードを設定します。
        # @param :: shipCountry 配送先国コード 
        #
        def ship_country=(shipCountry) 
            @ship_country = shipCountry
        end

        #
        # ===配送先郵便番号を取得する 
        # @return:: 配送先郵便番号 
        #
        def ship_postal_code 
            @ship_postal_code
        end

        #
        # ===配送先郵便番号を設定する 
        # - 配送先郵便番号を設定します。
        # - 全角文字を除く文字列を設定します。
        # - 配送先フラグに"1"を設定した場合は必須。
        # @param :: shipPostalCode 配送先郵便番号 
        #
        def ship_postal_code=(shipPostalCode) 
            @ship_postal_code = shipPostalCode
        end

        #
        # ===配送先電話番号を取得する 
        # @return:: 配送先電話番号 
        #
        def ship_phone 
            @ship_phone
        end

        #
        # ===配送先電話番号を設定する 
        # - 配送先電話番号を設定します。
        # - 全角文字を除く文字列を設定します。
        # @param :: shipPhone 配送先電話番号 
        #
        def ship_phone=(shipPhone) 
            @ship_phone = shipPhone
        end

        #
        # ===顧客番号を取得する 
        # @return:: 顧客番号 
        #
        def payer_id 
            @payer_id
        end

        #
        # ===顧客番号を設定する 
        # - 顧客番号を設定します。
        # - PayPalから処理が戻ってきたとき、URL（戻り先URL）に付加されています。
        # @param :: payerId 顧客番号 
        #
        def payer_id=(payerId) 
            @payer_id = payerId
        end

        #
        # ===トークンを取得する 
        # @return:: トークン 
        #
        def token 
            @token
        end

        #
        # ===トークンを設定する 
        # - トークンを設定します。
        # @param :: token トークン 
        #
        def token=(token) 
            @token = token
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
