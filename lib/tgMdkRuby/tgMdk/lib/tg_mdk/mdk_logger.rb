# -*- encoding: utf-8 -*-
#= mdk_logger.rb - 3GPS MDK Library ロガークラス
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
begin
  require 'log4r'
  require 'log4r/yamlconfigurator'
rescue LoadError
  require 'rubygems'
  require 'log4r'
  require 'log4r/yamlconfigurator'
end


module Veritrans
  module Tercerog
    module Mdk

      #
      # MdkLogger クラス
      #    Mdkで利用するデフォルトロガークラスを定義します。
      #
      class MdkLogger < Log4r::Logger

        #
        # ===コンストラクタ
        # @param:: _fullname ログ出力クラス識別名
        # @param:: config_file_name ログ設定ファイル名
        #
        def initialize(_fullname, config_file_name=nil)
          unless config_file_name
            config_file_name = "#{File.expand_path(File.dirname(__FILE__))}/../../tg_mdk_log4r.yaml"
          end

          Log4r::YamlConfigurator.load_yaml_file(config_file_name)
          super(_fullname)
        end

      end

    end
  end
end

