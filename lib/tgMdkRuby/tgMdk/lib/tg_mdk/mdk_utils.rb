# -*- encoding: utf-8 -*-
#= mdk_utils.rb - 3GPS MDK Library 共通ユーティリティモジュール
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

require 'openssl'
require 'time'
require 'tg_mdk/mdk_utils/string'
require 'rexml/parsers/pullparser'


module Veritrans
  module Tercerog
    module Mdk

      #
      # MdkUtils 共通ユーティリティモジュール
      #
      module MdkUtils

        #
        # ===引数データのダイジェストを取得して、返却します。
        # @param:: data ダイジェスト取得対象データ
        # @return:: ダイジェスト（16進文字列）
        #
        def mdk_digest(data)
          digest_algorithm = MdkConfig.instance.message_digest_type
          OpenSSL::Digest::Digest.hexdigest(digest_algorithm, data)
        end
        module_function :mdk_digest

        #
        # ===現在日時(例：20000101010101000)をグリニッジ標準時間で取得する
        # @return:: グリニッジ標準時間の現在日時
        #
        def mdk_gmtime
          Time.now.gmtime.instance_eval {
            '%s%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round]
          }
        end
        module_function :mdk_gmtime

        #
        # ===引数のデータをbase64エンコード（SAFE URL）した結果を返します。
        # @param:: data 対象データ
        # @return:: base64エンコード後のデータ（改行なし）
        #
        def mdk_base64_encode(data)
          [data].pack('m').gsub('/', '-').gsub('+', '_').gsub('=', '*').gsub(/\n/, '')
        end
        module_function :mdk_base64_encode

        #
        # ===引数のデータから改行コードを取り除いた値を返す
        # @param:: data 対象データ
        # @return:: 改行を取り除いたデータ
        #
        def mdk_delete_r_n(data)
          tmp = data.gsub("\r\n", "")
          tmp = tmp.gsub("\n", "")
          tmp
        end
        module_function :mdk_delete_r_n

        #
        # ===引数のXMLに必要なマスク処理を行ったXMLを返す
        # @param:: xml 対象XML文字列
        # @return:: マスク処理を行った後のXML文字列
        #
        def mdk_mask_xml(xml)
          # コンフィグクラス生成
          config = MdkConfig.instance
          # マスク項目を大文字化して取得
          mask_item_list = config[MdkConfig::MASK_ITEM].upcase.split(",")

          mask_flg = false

          # XMLパーサ
          parser = REXML::Parsers::PullParser.new(xml)
          mask_xml = ""

          while parser.has_next?
            # 要素取り出し
            res = parser.pull

            case res.event_type
            when :xmldecl
              mask_xml = mask_xml.concat "<?xml version=\"#{res[0]}\" encoding=\"#{res[1]}\"?>"
            when :start_element # 開始エレメントの場合
              mask_xml = mask_xml.concat "<#{res[0]}>"
              # 項目名がマスク化項目リストに含まれる場合はマスクフラグを設定
              if mask_item_list.index(res[0].upcase)
                mask_flg = true
              else
                mask_flg = false
              end
            when :text # 値の場合
              # マスク対象の場合はマスク化を行う
              if mask_flg
                mask_xml = mask_xml.concat res[0].gsub(/./, "*")
              else
                mask_xml = mask_xml.concat res[0]
              end
            when :end_element # 終了エレメントの場合
              mask_xml = mask_xml.concat "</#{res[0]}>"
            end
          end
          mask_xml
        end
        module_function :mdk_mask_xml

      end
    end
  end
end

