# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索条件:bank検索パラメータクラス
      #
      # @author:: t.honma
      #
      class BankSearchParameter

        #
        # ===詳細オーダー決済状態を取得する
        #
        # @return:: 詳細オーダー決済状態
        #
        def detail_order_type
          @detail_order_type
        end

        #
        # ===詳細オーダー決済状態を設定する
        #
        # @param:: detailOrderType 詳細オーダー決済状態
        #
        def detail_order_type=(detailOrderType)
          @detail_order_type = detailOrderType
        end

        #
        # ===支払い種別を取得する
        #
        # @return:: 支払い種別
        #
        def option_type
          @option_type
        end

        #
        # ===支払い種別を設定する
        #
        # @param:: optionType 支払い種別
        #
        def option_type=(optionType)
            @option_type = optionType
        end

        #
        # ===支払期限（From, To）を取得する
        #
        # @return:: 支払期限（From, To）
        #
        def pay_limit
          @pay_limit
        end

        #
        # ===支払期限（From, To）を設定する
        #
        # @param:: payLimit 支払期限（From, To）
        #
        def pay_limit=(payLimit)
          @pay_limit = payLimit
        end

        #
        # ===収納日時（From, To）を取得する
        #
        # @return:: 収納日時（From, To）
        #
        def received_datetime
          @received_datetime
        end

        #
        # ===収納日時（From, To）を設定する
        #
        # @param:: receivedDatetime 収納日時（From, To）
        #
        def received_datetime=(receivedDatetime)
          @received_datetime = receivedDatetime
        end

        #
        # ===収納機関番号を取得する
        #
        # @return:: 収納機関番号
        #
        def shuno_kikan_no
          @shuno_kikan_no
        end

        #
        # ===収納機関番号を設定する
        #
        # "*"によるワイルドカード検索が可能
        #
        # @param:: shunoKikanNo 収納機関番号
        #
        def shuno_kikan_no=(shunoKikanNo)
          @shuno_kikan_no = shunoKikanNo
        end

        #
        # ===収納企業コードを取得する
        #
        # @return:: 収納企業コード
        #
        def shuno_kigyo_no
          @shuno_kigyo_no
        end

        #
        # ===収納企業コードを設定する
        #
        # "*"によるワイルドカード検索が可能
        #
        # @param:: shunoKigyoNo 収納企業コード
        #
        def shuno_kigyo_no=(shunoKigyoNo)
          @shuno_kigyo_no = shunoKigyoNo
        end

        #
        # ===お客様番号を取得する
        #
        # @return:: お客様番号
        #
        def customer_no
          @customer_no
        end

        #
        # ===お客様番号を設定する
        #
        # "*"によるワイルドカード検索が可能
        #
        # @param:: customerNo お客様番号
        #
        def customer_no=(customerNo)
          @customer_no = customerNo
        end

        #
        # ===確認番号を取得する
        #
        # @return:: 確認番号
        #
        def confirm_no
          @confirm_no
        end

        #
        # ===確認番号を設定する
        #
        # "*"によるワイルドカード検索が可能
        #
        # @param:: confirmNo 確認番号
        #
        def confirm_no=(confirmNo)
          @confirm_no = confirmNo
        end

      end

    end
  end
end
