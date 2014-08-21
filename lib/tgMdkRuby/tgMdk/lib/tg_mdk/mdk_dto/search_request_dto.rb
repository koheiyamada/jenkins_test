# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/request_base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =決済サービスタイプ：Search 要求Dtoクラス
      #
      # @author:: t.honma
      #
      class SearchRequestDto < ::RequestBaseDto

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
        SERVICE_TYPE = "search"

        #
        # 決済サービスコマンド
        # 半角英数字
        # 必須項目、固定値
        #
        SERVICE_COMMAND = "Search"

        #
        # ===決済サービスタイプを取得する
        # @return:::: 決済サービスタイプ
        #
        def service_type
            @service_type
        end

        #
        # ===決済サービスコマンドを取得する
        # @return:::: 決済サービスコマンド
        #
        def service_command
            @service_command
        end

        #
        # ===リクエストIDを取得する
        #
        # @return:: リクエストID
        #
        def request_id
            @request_id
        end

        #
        # ===リクエストIDを設定する
        #
        # @param:: requestId リクエストID
        #
        def request_id=(requestId)
            @request_id = requestId
        end

        #
        # ===決済サービスタイプを取得する
        #
        # @return:: 決済サービスタイプ
        #
        def service_type_cd
            @service_type_cd
        end

        #
        # ===決済サービスタイプを設定する。
        #
        # 複数指定を可能とする。
        # 指定しない場合は全ての決済サービスタイプより検索されます。
        #
        # @param:: serviceTypeCd 決済サービスタイプ
        #
        def service_type_cd=(serviceTypeCd)
            @service_type_cd = serviceTypeCd
        end

        #
        # ===最新トランザクションのみフラグを取得する
        #
        # @return:: 最新トランザクションのみフラグ
        #
        def newer_flag
            @newer_flag
        end

        #
        # ===最新トランザクションのみフラグを設定する
        #
        # @param:: newerFlag 最新トランザクションのみフラグ
        #
        def newer_flag=(newerFlag)
            @newer_flag = newerFlag
        end


        #
        # ===ダミー決済対象フラグを取得する
        #
        # @return:: ダミー決済対象フラグ
        #
        def contain_dummy_flag
            @contain_dummy_flag
        end

        #
        # ===ダミー決済対象フラグを設定する
        #
        # @param:: containDummyFlag ダミー決済対象フラグ
        #
        def contain_dummy_flag=(containDummyFlag)
            @contain_dummy_flag = containDummyFlag
        end

        #
        # ===検索最大件数を取得する
        #
        # @return:: 検索最大件数
        #
        def max_count
            @max_count
        end

        #
        # ===検索最大件数を設定する
        #
        # @param:: maxCount 検索最大件数
        #
        def max_count=(maxCount)
            @max_count = maxCount
        end

        #
        # ===マスタ名を取得する
        #
        # @return:: マスタ名
        #
        def master_names
            @master_names
        end

        #
        # ===マスタ名を設定する
        #
        # @param:: masterNames マスタ名
        #
        def master_names=(masterNames)
            @master_names = masterNames
        end

        #
        # ===検索キーを取得する
        #
        # @return:: 検索キー
        #
        def search_parameters
            @search_parameters
        end

        #
        # ===検索キーを設定する
        #
        # @param:: searchParameters 検索キー
        #
        def search_parameters=(searchParameters)
            @search_parameters = searchParameters
        end

        #
        # ===ログ用文字列(マスク済み)を設定する
        # @param::  maskedLog ログ用文字列(マスク済み)
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

      end
    end
  end
end
