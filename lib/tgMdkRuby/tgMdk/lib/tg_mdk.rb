# -*- encoding: utf-8 -*-
#= tg_mdk.rb - 3GPS MDK Library main file.
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
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Veritrans
  VERSION = '1.0.0'

  module Tercerog
    module Mdk
      #
      # ===Mdkが共通で利用するロガーを取得します。
      # @return:: ログ出力用クラスのインスタンス
      #
      def self.logger
        if defined?(MDK_DEFAULT_LOGGER)
          MDK_DEFAULT_LOGGER
        else
          nil
        end
      end
    end
  end
end

require 'tg_mdk/mdk_logger'
require 'tg_mdk/mdk_message'
require 'tg_mdk/mdk_error'
require 'tg_mdk/mdk_utils'
require 'tg_mdk/mdk_config'
require 'tg_mdk/mdk_dto'
require 'tg_mdk/mdk_n_v_query'
require 'tg_mdk/mdk_connection'
require 'tg_mdk/mdk_connection_servlet'
require 'tg_mdk/mdk_content_handler'
require 'tg_mdk/mdk_transaction'
require 'tg_mdk/mdk_merchant_utility'

