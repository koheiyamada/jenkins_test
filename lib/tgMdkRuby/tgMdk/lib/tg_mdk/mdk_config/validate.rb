# -*- encoding: utf-8 -*-
#= mdk_config/validate.rb - 3GPS MDK Library 設定ファイルクラス
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
      #    各設定ファイルの設定値を検証します。
      #
      class MdkConfig

        #
        # ===検証エラーの例外［Array］を取得します。
        # @return:: 検証時に発生した例外のリスト[Array]
        # 
        def errors
          @errors
        end

        #
        # ===パラメータを検証します。
        # @param:: valid_only trueの場合、検証のみ実行します。
        #         falseの場合、検証エラー時、例外をraiseします。 
        # @return:: true: 検証成功、false: 検証エラー
        # 
        def valid?(valid_only = false)
          # store exception
          @errors = []

          # PROTOCOL
          presence_of?(PROTOCOL, protocol)
          format_of?(PROTOCOL, protocol,
              /^soap_ws_security$
              |^soap_no_security$
              |^get$
              |^post$
              |^post_no_security$/ix
            )

          # DUMMY_REQUEST
          presence_of?(DUMMY_REQUEST, dummy_request)
          numeric_of?(DUMMY_REQUEST, dummy_request)

          # MDK_ERROR_MODE
          presence_of?(MDK_ERROR_MODE, mdk_error_mode)
          numeric_of?(MDK_ERROR_MODE, mdk_error_mode)

          # MDK_VERSION
          presence_of?(MDK_VERSION, mdk_version)

          # MDK_DTO_VERSION
          presence_of?(MDK_DTO_VERSION, mdk_dto_version)

          # MERCHANT_CC_ID
          presence_of?(MERCHANT_CC_ID, merchant_cc_id)

          # MERCHANT_SECRET_KEY
          presence_of?(MERCHANT_SECRET_KEY, merchant_secret_key)

          # CONNECTION_TIMEOUT
          presence_of?(CONNECTION_TIMEOUT, connection_timeout)
          numeric_of?(CONNECTION_TIMEOUT, connection_timeout)

          # CA_CERT_FILE
          presence_of?(CA_CERT_FILE, ca_cert_file)
          exist_of?(CA_CERT_FILE, ca_cert_file)

          # TARGET_HOST_POST_NO_SECURITY
          presence_of?(TARGET_HOST_POST_NO_SECURITY, target_host_post_no_security)
          format_of?(TARGET_HOST_POST_NO_SECURITY, target_host_post_no_security, 
                    /^https:\/\/(\w)+(\.\w)*/i)
            
          #2012.01.30: start
          #don't check TRIPARTITE_URL and TRIPARTITE_SJIS_URL see #7
          # TRIPARTITE_URL
          #presence_of?(TRIPARTITE_URL, tripartite_url)
          #format_of?(TRIPARTITE_URL, tripartite_url, 
          #          /^https:\/\/(\w)+(\.\w)*/i)
            
          # TRIPARTITE_SJIS_URL
          #presence_of?(TRIPARTITE_SJIS_URL, tripartite_sjis_url)
          #format_of?(TRIPARTITE_SJIS_URL, tripartite_sjis_url,
          #          /^https:\/\/(\w)+(\.\w)*/i)
          #2012.01.30: end.

          # COMMON_ITEM
          presence_of?(COMMON_ITEM, common_item)

          # MASK_ITEM
          presence_of?(MASK_ITEM, mask_item)

          # MESSAGE_DIGEST_TYPE
          presence_of?(MESSAGE_DIGEST_TYPE, message_digest_type)

          ############################################################# PHASE 2
          ## GET/POST/POST_NO_SECURITY時のパラメータチェック
          if /^get$|^post$|^soap_ws_security$/ix =~ protocol
            # to be PHASE 2

            presence_of?(CLIENT_CERT_FILE, client_cert_file)
            exist_of?(CLIENT_CERT_FILE, client_cert_file)
          end
          ############################################################# PHASE 2


          if valid_only
            return @errors.empty? ? true : false
          else
            # エラーがある場合は、先頭の例外をスローします。
            raise @errors.first unless @errors.empty?
            return true
          end
        end
        
        #
        # ===必須パラメータチェック
        # @param:: key 検証対象項目
        # @param:: value 検証対象の値
        #
        # @return:: true: 検証成功、false: 検証エラー
        #
        def presence_of?(key, value)
          return true unless value.nil? or value.empty?

          @errors << MdkError.new(MdkMessage::MA01_CONFIG_MISSING, key)
          false
        end

        #
        # ===書式チェック
        # @param:: key 検証対象項目
        # @param:: value 検証対象の値
        # @param:: regexp 検証対象の書式、正規表現[Regexp]
        #
        # @return:: true: 検証成功、false: 検証エラー
        #
        def format_of?(key, value, regexp)
          return true if regexp =~ value

          @errors << MdkError.new(MdkMessage::MA02_CONFIG_NOT_CORRECT, key, value)
          false
        end

        #
        # ===数値チェック
        # @param:: key 検証対象項目
        # @param:: value 検証対象の値
        #
        # @return:: true: 検証成功、false: 検証エラー
        #
        def numeric_of?(key, value)
          return true if /^([1-9]\d*|0)(\.\d+)?$/ =~ value
          
          @errors << MdkError.new(MdkMessage::MA02_CONFIG_NOT_CORRECT, key, value)
          false
        end

        #
        # ===ファイル存在チェック
        # @param:: key 検証対象項目
        # @param:: value 検証対象の値
        #
        # @return:: true: 検証成功、false: 検証エラー
        #
        def exist_of?(key, value)
          return true if File.exist?(value)

          @errors << MdkError.new(MdkMessage::MA03_FILE_DOES_NOT_EXIST, key)
          false
        end
        private :presence_of?, :format_of?, :numeric_of?, :exist_of?

      end
    end
  end
end

