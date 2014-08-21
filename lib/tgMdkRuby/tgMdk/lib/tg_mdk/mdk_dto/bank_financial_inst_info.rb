# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =金融機関マスタ情報
      #
      # @author:: t.honma
      #
      class BankFinancialInstInfo

        #
        # ===金融機関コードを取得する
        #
        # @return:: 金融機関コード
        #
        def bank_code
          @bank_code
        end

        #
        # ===金融機関コードを設定する
        #
        # @param:: bankCode 金融機関コード
        #
        def bank_code=(bankCode)
          @bank_code = bankCode
        end

        #
        # ===デバイスコードを取得する
        #
        # @return:: デバイスコード
        #
        def device_code
          @device_code
        end

        #
        # ===デバイスコードを設定する
        #
        # @param:: deviceCode デバイスコードコード
        #
        def device_code=(deviceCode)
          @device_code = deviceCode
        end

        #
        # ===金融機関名称を取得する
        #
        # @return:: 金融機関名称
        #
        def bank_name
          @bank_name
        end

        #
        # ===金融機関名称を設定する
        #
        # @param:: bankName 金融機関名称
        #
        def bank_name=(bankName)
          @bank_name = bankName
        end

        #
        # ===金融機関カナを取得する
        #
        # @return:: 金融機関カナ
        #
        def bank_kana
          @bank_kana
        end

        #
        # ===金融機関カナを設定する
        #
        # @param:: bankKana 金融機関カナ
        #
        def bank_kana=(bankKana)
          @bank_kana = bankKana
        end

        #
        # ===カナ頭文字を取得する
        #
        # @return:: カナ頭文字
        #
        def bank_index_char1
          @bank_index_char1
        end

        #
        # ===カナ頭文字を設定する
        #
        # @param:: bankIndexChar1 カナ頭文字
        #
        def bank_index_char1=(bankIndexChar1)
          @bank_index_char1 = bankIndexChar1
        end

        #
        # ===カナ行頭文字を取得する
        #
        # @return:: カナ行頭文字
        #
        def bank_index_char2
          @bank_index_char2
        end

        #
        # ===カナ行頭文字を設定する
        #
        # @param:: bankIndexChar2 カナ行頭文字
        #
        def bank_index_char2=(bankIndexChar2)
          @bank_index_char2 = bankIndexChar2
        end

        #
        # ===登録日時(yyyymmddhhmmss)を取得する
        #
        # @return:: 登録日時
        #
        def start_datetime
          @start_datetime
        end

        #
        # ===登録日時を設定する
        #
        # @param:: startDatetime 登録日時
        #
        def start_datetime=(startDatetime)
          @start_datetime = startDatetime
        end
      end

    end
  end
end