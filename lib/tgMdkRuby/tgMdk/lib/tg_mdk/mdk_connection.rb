# -*- encoding: utf-8 -*-
#= mdk_connection.rb - 3GPS MDK Library 接続管理クラス
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

require 'tg_mdk/mdk_connection_servlet'

module Veritrans
  module Tercerog
    module Mdk
      #
      # MdkConnection クラス
      #    接続管理クラス
      #
      class MdkConnection

        #
        # ===接続メソッド
        # 処理を分岐して、Servletにて接続を行う
        # @param param 送信するパラメータ
        # @return 処理結果
        #
        def execute(param)
          # コンフィグクラス生成
          config = Veritrans::Tercerog::Mdk::MdkConfig.instance

          rtn_str = ""
          case config[MdkConfig::PROTOCOL]
          when "POST_NO_SECURITY"
            # ConnectionServletクラス生成
            connection = Veritrans::Tercerog::Mdk::MdkConnectionServlet.new

            # execute実行
            rtn_str = connection.execute(param)
          else
            raise MdkError.new(MdkMessage::MA02_CONFIG_NOT_CORRECT, 
                            MdkConfig::PROTOCOL, config[MdkConfig::PROTOCOL])
          end
          rtn_str
        end

      end
    end
  end
end
