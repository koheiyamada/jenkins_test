# -*- encoding: utf-8 -*-
#= mdk_connection_servlet.rb - 3GPS MDK Library サーブレット接続クラス
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

require 'net/https'
require 'uri'
require 'socket'
require 'timeout'


module Veritrans
  module Tercerog
    module Mdk
      #
      # MdkConnectionServlet クラス
      #    サーブレット接続クラス
      #
      class MdkConnectionServlet

        #
        # ===コンストラクタ
        # コンフィグファイルからデータを取得して当クラスを使用できる状態にする。
        # パラメータuse_default_confがFALSEの場合はデフォルト値を設定しない。
        # @param:: use_default_conf デフォルトのConfigファイルからデータを取得するかを指定するフラグ
        #
        def initialize(use_default_conf = true)

          # プロキシを使用するかを示すフラグ
          @use_proxy = false
          # プロキシのホスト
          @proxy_host = nil
          # プロキシのポート
          @proxy_port = nil
          # プロキシのユーザ
          @proxy_username = nil
          # プロキシのユーザのパスワード
          @proxy_password = nil

          # 接続ターゲットのプロトコル
          @target_protocol = nil
          # 接続ターゲットのホスト
          @target_host = nil
          # 接続ターゲットのポート
          @target_port = nil
          # 接続ターゲットURL(コンテキストルート以降)
          @target_path = nil

          # User-Agent情報
          @user_agent = nil

          # コネクションタイムアウト
          @connection_timeout = 0

          # 公開鍵ファイルパス
          @ca_cert_file = nil

          # コンフィグクラスのインスタンス設定
          @config = Veritrans::Tercerog::Mdk::MdkConfig.instance

          # デフォルト値を設定
          set_default_config if use_default_conf
        end

        #
        # ===当クラスをConfigファイルを使用して値を設定する
        #
        def set_default_config()

          # 通信プロトコル設定
          @target_protocol = @config[MdkConfig::PROTOCOL]

          # Proxy情報設定
          # 2010/08/06 y.kawahara - PROXY空文字指定でエラーになるバグ修正
          if @config[MdkConfig::PROXY_SERVER_URL] and
              @config[MdkConfig::PROXY_SERVER_URL].strip.length > 0
            proxy_url = URI.parse(@config[MdkConfig::PROXY_SERVER_URL])
            @proxy_host = proxy_url.host
            @proxy_port = proxy_url.port
            @proxy_username = @config[MdkConfig::PROXY_USERNAME]
            @proxy_password = @config[MdkConfig::PROXY_PASSWORD]
            @use_proxy = true
          end

          # 接続先の情報と送信するデータ内容をログ出力
          Mdk::logger.debug("connect 3gw url ==> " + @config["TARGET_HOST_" + @target_protocol])
          
          # GW情報設定
          target_url = URI.parse(@config["TARGET_HOST_" + @target_protocol])
          @target_host = target_url.host
          @target_port = target_url.port
          @target_path = target_url.path

          # コネクションタイムアウト設定
          @connection_timeout = @config[MdkConfig::CONNECTION_TIMEOUT].to_f
          # 公開鍵ファイルパス設定
          @ca_cert_file = @config[MdkConfig::CA_CERT_FILE]
        end
        private :set_default_config

        #
        # ===Servlet接続メソッド
        # @param param 送信するパラメータ
        # @return 処理結果
        #
        def execute(param)
          # Proxyを使用する場合
          if @use_proxy
            proxy_checker
            https = Net::HTTP::Proxy(@proxy_host, @proxy_port, @proxy_username, @proxy_password).new(@target_host, @target_port)
          else
            https = Net::HTTP.new(@target_host, @target_port)
          end
          https.use_ssl = true
          https.ca_file = @ca_cert_file
          https.verify_mode = OpenSSL::SSL::VERIFY_PEER
          https.open_timeout = @connection_timeout
          https.read_timeout = @connection_timeout

          header = {
            "user-agent" => @config.get_user_agent
          }

          # POST送信
          rtn_str = ""
          https.start {|w|
            response = w.post(@target_path, param, header)

            # 応答電文のHTTPステータスチェック
            http_result_checker(response.code)

            # 応答電文設定
            rtn_str = response.body
          }

          rtn_str
        rescue OpenSSL::SSL::SSLError => e
          raise MdkError, MdkMessage::MB03_SSLSOCKET_CREATION_FAILED
        rescue Timeout::Error => e
          raise MdkError, MdkMessage::MF03_SERVER_TIME_OUT
        rescue Net::HTTPServerException => e
          raise MdkError, MdkMessage::MF99_SYSTEM_INTERNAL_ERROR
        end

        #
        # ===HTTPステータスを判断して例外を発生させ
        # @param param HTTPステータス
        #
        def http_result_checker(resultCode)
          # nilチェック
          if resultCode == nil
            raise MdkError, MdkMessage::MF02_CANNOT_CONNECT_TO_GW
          end
          
          case resultCode
          when "200"
            # 正常終了  以下、異常終了
          when "500"
            raise MdkError, MdkMessage::MF05_INTERNAL_SERVER_ERROR
          when "502"
            raise MdkError, MdkMessage::MF06_BAD_GW
          when "503"
            raise MdkError, MdkMessage::MF07_SERVICE_UNAVAILABLE
          else
            raise MdkError, MdkMessage::MF02_CANNOT_CONNECT_TO_GW
          end
        end
        private :http_result_checker

        #
        # ===PROXYサーバ接続確認
        #
        def proxy_checker
          sock = nil
          Timeout::timeout(@connection_timeout) {
            sock = TCPSocket.open(@proxy_host, @proxy_port)
          }
          auth = [ [@proxy_username, @proxy_password].join(':') ].pack('m')
          req = []
          # 2010/08/06 y.kawahara - PROXY接続で403エラーになるバグを修正
          req << "CONNECT #{@target_host}:#{@target_port} HTTP/1.0"
          req << "Host: #{@target_host}:#{@target_port}"
          req << "Proxy-Authorization: basic #{auth}"
          req << ""

          sock.write(req.join("\r\n"))
          sock_res = sock.gets
          sock.close
          res_code = sock_res.match(/^HTTP\/1\.. (\d+)/).to_a[1]
          if res_code != nil and res_code.size > 0
            if res_code != "200"
              raise MdkError.new(MdkMessage::MF01_PROXY_ERROR, sock_res.chomp)
            end
          end
        end

      end
    end
  end
end

