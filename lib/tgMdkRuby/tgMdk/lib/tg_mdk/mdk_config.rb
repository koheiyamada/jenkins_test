# -*- encoding: utf-8 -*-
#= mdk_config.rb - 3GPS MDK Library 設定ファイルクラス
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

require 'tg_mdk/mdk_config/const'
require 'tg_mdk/mdk_config/validate'

module Veritrans
  module Tercerog
    module Mdk
      #
      # MdkConfig クラス
      #    各設定ファイルから値を取得するインターフェイスを提供します。
      #
      class MdkConfig

        # シングルトン用インスタンス
        @@instance = nil

        #
        # ===このクラスで唯一のインスタンスを取得します。
        # @return:: インスタンス
        # 
        def self.instance(*user_properties)
          @@instance ||= new(*user_properties)
        end

        
        # 
        # ===コンストラクタ（private）
        # @param:: user_properties ユーザ定義のプロパティファイル（可変長指定）
        # 
        def initialize(*user_properties)
          tg_mdk_directory = File.expand_path(File.dirname(__FILE__))
          mdk_root_directory = "#{tg_mdk_directory}/../.."

          @errors ||= []
          @properties = {}
          @propertie_files = [mdk_root_directory + "/tg_mdk.ini",
                              tg_mdk_directory + "/internal.ini",
                              tg_mdk_directory + "/mdk_dto/dto.ini"]
          @propertie_files.concat(user_properties) unless user_properties.empty?

          build_properties
          define_propertie_methods
        end
        private_class_method :new

        # 
        # ===プロパティファイルを読み取り、インスタンス変数[Hash]にセットします。
        # 
        def build_properties
          @propertie_files.each do |propertie_file|
            unless File.readable?(propertie_file)
              raise MdkError.new(MdkMessage::MB01_NOT_FOUND_CONFIG_FILE, propertie_file)
            end
            open(propertie_file).read.scan(/^\w.*/) do |line|
              key, value = line.split('=')
              @properties[key.strip.to_sym] = value.strip if key
            end
          end
        rescue => e
          raise e
        end
        private :build_properties

        # 
        # ===各パラメータへプロパティとしてアクセスするメソッドを定義します。
        # 
        def define_propertie_methods
          MdkConfig.constants.each do |const|
            MdkConfig.class_eval do
              define_method const.downcase.intern do
                @properties[const.intern]
              end
            end
          end
        end
        private :define_propertie_methods

        # 
        # ===各パラメータへHashとしてアクセスするメソッドを定義します。
        # 
        def [](key)
          return nil if key.nil?
          if key.kind_of? Symbol
            @properties[key]
          elsif key.kind_of? String
            @properties[key.intern]
          else
            nil
          end
        end

        # ===キーに対応する値を上書き設定します
        #
        def overwrite(key, value)
          @properties[key.strip.to_sym] = value.strip
        end

        #
        # ===電文のヘッダ情報に載せるuser-agent情報の文字列を返す。
        #
        def get_user_agent()
          mdk_ver = self["MDK_VERSION"]
          mdk_dto_ver = self["MDK_DTO_VERSION"]
          ruby_ver = RUBY_VERSION
          protocol = self["PROTOCOL"]
          return "VeriTrans 3GMDK/#{mdk_ver}/#{mdk_dto_ver} (Ruby #{ruby_ver}; #{protocol})"
        end
      end
    end
  end
end

