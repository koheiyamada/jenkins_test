# -*- encoding: utf-8 -*-
#= mdk_message.rb - 3GPS MDK Library メッセージ管理クラス
#
#Copyright:: 2010 SBI VeriTrans Co., Ltd.
#License::   http://www.veritrans.co.jp/3gpslicense   Veritrans License
#Version::   $Id:$
#Authors::   SBI VeriTrans Co., Ltd.
#
#=== 開発履歴
#
#* 1.0.0 2010-05-06
#  * First commit version.
#

require 'singleton'

module Veritrans
  module Tercerog
    module Mdk
      #
      # MdkMessage クラス
      #    メッセージファイルからメッセージを取得するクラス
      #
      class MdkMessage
        include Singleton

        # エラーを示す定数 ： プロパティファイル読み込みエラー
        MA01_CONFIG_MISSING             = "MA01"
        #  エラーを示す定数 ： プロパティ書式エラー
        MA02_CONFIG_NOT_CORRECT         = "MA02"
        #  エラーを示す定数 ： ファイル存在チェックエラー
        MA03_FILE_DOES_NOT_EXIST        = "MA03"
        #  エラーを示す定数 ： 暗号化エラー
        MA04_MESSAGE_ENCRYPT_ERROR      = "MA04"
        #  エラーを示す定数 ： エラーメッセージファイル読み込みエラー
        MA05_CONF_FILE_DOES_NOT_EXIST   = "MA05"
        #  エラーを示す定数 ： 復号化エラー
        MA06_MESSAGE_DECRYPT_ERROR      = "MA06"
        #  エラーを示す定数 ： DTOの設定値の型エラー
        MA07_INVALID_DTO_VALUE_TYPE     = "MA07"
        #  エラーを示す定数 ： アプリケーション系の予期しないエラー
        MA99_SYSTEM_INTERNAL_ERROR      = "MA99"

        ## 設定関係
        #  エラーを示す定数 ： プロパティファイル読み込みエラー
        MB01_NOT_FOUND_CONFIG_FILE      = "MB01"
        #  エラーを示す定数 ：
        MB02_CANNOT_READ_CONFIG_FILE    = "MB02"
        #  エラーを示す定数 ： SSL通信時の暗号に失敗
        MB03_SSLSOCKET_CREATION_FAILED  = "MB03"
        #  エラーを示す定数 ： 設定関係の予期しないエラー
        MB99_SYSTEM_INTERNAL_ERROR      = "MB99"

        ## 内部通信エラー
        #  エラーを示す定数 ： プロキシサーバへの接続エラー
        MF01_PROXY_ERROR                = "MF01"
        #  エラーを示す定数 ： 3GPSサーバへの接続エラー
        MF02_CANNOT_CONNECT_TO_GW       = "MF02"
        #  エラーを示す定数 ： サーバタイムアウトの場合
        MF03_SERVER_TIME_OUT            = "MF03"
        #  エラーを示す定数 ： HTTPステータス：500 予期しないエラー
        MF05_INTERNAL_SERVER_ERROR      = "MF05"
        #  エラーを示す定数 ： HTTPステータス：502 不正なレスポンスを受信
        MF06_BAD_GW                     = "MF06"
        #  エラーを示す定数 ： HTTPステータス：503 サーバがリクエストを処理できない
        MF07_SERVICE_UNAVAILABLE        = "MF07"
        #  エラーを示す定数 ： 通信系の予期しないエラー
        MF99_SYSTEM_INTERNAL_ERROR      = "MF99"
        
        #
        # ===コンストラクタ
        #
        def initialize()
          base_directory = File.expand_path(File.dirname(__FILE__))

          @propertie_file = base_directory + "/errormessage.ini"
          @message_hash = Hash.new

          open(@propertie_file).read.scan(/^\w.*/){ |kv|
            key, value = kv.split('=')
            @message_hash[key.strip] = value.strip if key
          }
        end

        #
        # ===エラーメッセージを取得する
        # @param:: messageId メッセージID
        # @param:: comment メッセージを置き換える可変長引数
        # @return:: 取得したメッセージ
        #
        def get_message(messageId, *comment)
          msg = @message_hash[messageId]

          if messageId.nil? || msg.nil?
            raise ArgumentError, "messageId"
          end

          message = msg.dup
          comment.each_with_index do |i, count|
            message.sub!('#'.concat(count.to_s), i.to_s)
          end
          message
        end
      end
    end
  end
end

