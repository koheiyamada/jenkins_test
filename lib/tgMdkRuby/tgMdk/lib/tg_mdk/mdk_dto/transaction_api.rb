# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索結果:SaisonトランザクションAPI情報電文のクラス
      #
      # @author:: Created automatically by DtoCreator
      #
      class TransactionApi


        #
        # ===API種別を設定する
        # @param :: sa_api_kind API種別
        #
        def sa_api_kind=(sa_api_kind)
            @sa_api_kind = sa_api_kind
        end

        #
        # ===API種別を取得する
        # @return:: API種別
        #
        def sa_api_kind
            @sa_api_kind
        end

        #
        # ===リクエスト日時を設定する
        # @param :: request_datetime リクエスト日時
        #
        def request_datetime=(request_datetime)
            @request_datetime = request_datetime
        end

        #
        # ===リクエスト日時を取得する
        # @return:: リクエスト日時
        #
        def request_datetime
            @request_datetime
        end

        #
        # ===リクエストIDを設定する
        # @param :: request_id リクエストID
        #
        def request_id=(request_id)
            @request_id = request_id
        end

        #
        # ===リクエストIDを取得する
        # @return:: リクエストID
        #
        def request_id
            @request_id
        end

        #
        # ===対象API取引IDを設定する
        # @param :: target_deal_id 対象API取引ID
        #
        def target_deal_id=(target_deal_id)
            @target_deal_id = target_deal_id
        end

        #
        # ===対象API取引IDを取得する
        # @return:: 対象API取引ID
        #
        def target_deal_id
            @target_deal_id
        end

        #
        # ===利用ポイント数を設定する
        # @param :: use_point 利用ポイント数
        #
        def use_point=(use_point)
            @use_point = use_point
        end

        #
        # ===利用ポイント数を取得する
        # @return:: 利用ポイント数
        #
        def use_point
            @use_point
        end

        #
        # ===付与ポイント数を設定する
        # @param :: grant_point 付与ポイント数
        #
        def grant_point=(grant_point)
            @grant_point = grant_point
        end

        #
        # ===付与ポイント数を取得する
        # @return:: 付与ポイント数
        #
        def grant_point
            @grant_point
        end

        #
        # ===追加情報（利用年月日）を設定する
        # @param :: add_info_use_date 追加情報（利用年月日）
        #
        def add_info_use_date=(add_info_use_date)
            @add_info_use_date = add_info_use_date
        end

        #
        # ===追加情報（利用年月日）を取得する
        # @return:: 追加情報（利用年月日）
        #
        def add_info_use_date
            @add_info_use_date
        end

        #
        # ===追加情報（店舗名）を設定する
        # @param :: add_info_shop_name 追加情報（店舗名）
        #
        def add_info_shop_name=(add_info_shop_name)
            @add_info_shop_name = add_info_shop_name
        end

        #
        # ===追加情報（店舗名）を取得する
        # @return:: 追加情報（店舗名）
        #
        def add_info_shop_name
            @add_info_shop_name
        end

        #
        # ===追加情報（ウォレット決済金額）を設定する
        # @param :: add_info_wallet_amount 追加情報（ウォレット決済金額）
        #
        def add_info_wallet_amount=(add_info_wallet_amount)
            @add_info_wallet_amount = add_info_wallet_amount
        end

        #
        # ===追加情報（ウォレット決済金額）を取得する
        # @return:: 追加情報（ウォレット決済金額）
        #
        def add_info_wallet_amount
            @add_info_wallet_amount
        end

        #
        # ===追加情報4を設定する
        # @param :: add_info4 追加情報4
        #
        def add_info4=(add_info4)
            @add_info4 = add_info4
        end

        #
        # ===追加情報4を取得する
        # @return:: 追加情報4
        #
        def add_info4
            @add_info4
        end

        #
        # ===追加情報5を設定する
        # @param :: add_info5 追加情報5
        #
        def add_info5=(add_info5)
            @add_info5 = add_info5
        end

        #
        # ===追加情報5を取得する
        # @return:: 追加情報5
        #
        def add_info5
            @add_info5
        end

        #
        # ===レスポンス日時を設定する
        # @param :: aq_response_datetime レスポンス日時
        #
        def aq_response_datetime=(aq_response_datetime)
            @aq_response_datetime = aq_response_datetime
        end

        #
        # ===レスポンス日時を取得する
        # @return:: レスポンス日時
        #
        def aq_response_datetime
            @aq_response_datetime
        end

        #
        # ===API取引IDを設定する
        # @param :: aq_deal_id API取引ID
        #
        def aq_deal_id=(aq_deal_id)
            @aq_deal_id = aq_deal_id
        end

        #
        # ===API取引IDを取得する
        # @return:: API取引ID
        #
        def aq_deal_id
            @aq_deal_id
        end

        #
        # ===処理後ポイント残高を設定する
        # @param :: aq_point_balance 処理後ポイント残高
        #
        def aq_point_balance=(aq_point_balance)
            @aq_point_balance = aq_point_balance
        end

        #
        # ===処理後ポイント残高を取得する
        # @return:: 処理後ポイント残高
        #
        def aq_point_balance
            @aq_point_balance
        end


      end
    end
  end
end
