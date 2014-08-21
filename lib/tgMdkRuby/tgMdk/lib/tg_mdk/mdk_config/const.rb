# -*- encoding: utf-8 -*-
#= mdk_config/const.rb - 3GPS MDK Library 設定ファイルクラス
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

module Veritrans
  module Tercerog
    module Mdk

      #
      # MdkConfig クラス
      #    各設定ファイルに定義されているキーの定数を定義します。
      #
      class MdkConfig

        #
        # tg_mdk.properties
        #
        
        # ダミーモード（テスト時のみ指定します）
        DUMMY_REQUEST                 = "DUMMY_REQUEST".freeze

        # MDK固有エラーモード(テスト時のみ指定します）
        MDK_ERROR_MODE                = "MDK_ERROR_MODE".freeze
        
        # 送信方法
        PROTOCOL                      = "PROTOCOL".freeze

        # 二者間POST(Securityなし)送信URL
        TARGET_HOST_POST_NO_SECURITY  = "TARGET_HOST_POST_NO_SECURITY".freeze
        
        # 三者間送信URL(UTF-8版)
        TRIPARTITE_URL                = "TRIPARTITE_URL".freeze
        
        # 三者間送信URL(Shift_JIS版)
        TRIPARTITE_SJIS_URL           = "TRIPARTITE_SJIS_URL".freeze
        
        # 接続タイムアウト時間(秒)
        CONNECTION_TIMEOUT            = "CONNECTION_TIMEOUT".freeze

        # SSL暗号用 CA証明書ファイル名
        CA_CERT_FILE                  = "CA_CERT_FILE".freeze

        # プロキシのURLを指定します(未指定若しくは当プロパティを指定しない場合、プロキシなしとして扱います)
        PROXY_SERVER_URL              = "PROXY_SERVER_URL".freeze
        
        # プロキシユーザ名
        PROXY_USERNAME                = "PROXY_USERNAME".freeze
        
        # プロキシパスワード
        PROXY_PASSWORD                = "PROXY_PASSWORD".freeze

        # マーチャントCCID。VeriTrans指定のものを設定します。
        MERCHANT_CC_ID                = "MERCHANT_CC_ID".freeze
        
        # マーチャントパスワード。VeriTrans指定のものを設定します。
        MERCHANT_SECRET_KEY           = "MERCHANT_SECRET_KEY".freeze

        # 要求、応答DTOに設定される文字列のエンコード
        DTO_ENCODE                    = "DTO_ENCODE".freeze

        # internal.properties
        
        # MDKのバージョンを指定します。
        MDK_VERSION                   = "MDK_VERSION".freeze
        
        # DTOのバージョンを指定します。
        MDK_DTO_VERSION               = "MDK_DTO_VERSION".freeze
        
        # 共通アイテム
        COMMON_ITEM                   = "COMMON_ITEM".freeze
        
        # マスク対象アイテム
        MASK_ITEM                     = "MASK_ITEM".freeze
        
        # メッセージダイジェストタイプ
        MESSAGE_DIGEST_TYPE           = "MESSAGE_DIGEST_TYPE".freeze
        
# == Phase 2
#        TRUST_CERT_FILE               = "TRUST_CERT_FILE".freeze
#        PRIVATE_CERT_FILE             = "PRIVATE_CERT_FILE".freeze
#        PRIVATE_CERT_PASSWORD         = "PRIVATE_CERT_PASSWORD".freeze
#        TARGET_HOST_SOAP_NO_SECURITY  = "TARGET_HOST_SOAP_NO_SECURITY".freeze
#        TARGET_HOST_GET               = "TARGET_HOST_GET".freeze
#        TARGET_HOST_POST              = "TARGET_HOST_POST".freeze
#        CLIENT_CERT_FILE              = "CLIENT_CERT_FILE".freeze
#        CLIENT_CERT_PASSWORD          = "CLIENT_CERT_PASSWORD".freeze
#        BODY_ENCRYPT_SVR_ALIAS_NAME   = "BODY_ENCRYPT_SVR_ALIAS_NAME".freeze
#        BODY_ENCRYPT_MDK_ALIAS_NAME   = "BODY_ENCRYPT_MDK_ALIAS_NAME".freeze

      end
    end
  end
end

