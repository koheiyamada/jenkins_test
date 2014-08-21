# -*- encoding: utf-8 -*-
#= mdk_merchant_utility.rb - 3GPS MDK Library マーチャントユーティリティ
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
require 'cgi'

module Veritrans
  module Tercerog
    module Mdk
      #
      # MdkMerchantUtility モジュール
      #
      module MdkMerchantUtility

        #
        # ===３者間通信用メッセージダイジェストを取得します。
        #
        def get_tripartite_auth_hash
          conf = MdkConfig.instance

          merchant_cc_id = conf.merchant_cc_id
          gmnow = MdkUtils::mdk_gmtime
          merchant_secret_key = conf.merchant_secret_key
          hash = MdkUtils::mdk_digest(merchant_cc_id + gmnow + merchant_secret_key)

          [
            MdkUtils::mdk_base64_encode(merchant_cc_id),
            MdkUtils::mdk_base64_encode(gmnow),
            MdkUtils::mdk_base64_encode(hash),
          ].join('-')
        end
        module_function :get_tripartite_auth_hash


        #
        # ===３者間通信用のリダイレクト先URLを取得します。(UTF-8版)
        #
        def get_tripartite_url
          MdkConfig.instance.tripartite_url
        end
        module_function :get_tripartite_url


        #
        # ===３者間通信用のリダイレクト先URLを取得します。(Shift_JIS版)
        #
        def get_tripartite_sjis_url
          MdkConfig.instance.tripartite_sjis_url
        end
        module_function :get_tripartite_sjis_url

        #
        # ===署名を検証します。
        # @param:: message_body メッセージ
        # @param:: content_hmac 検証用に利用する署名
        # @return:: true: 検証成功、 false： 検証失敗
        # 
        def check_message?(message_body, content_hmac)
          if message_body.nil? or message_body.empty?
            return false
          end

          if content_hmac.nil? or content_hmac.empty?
            return false
          end

          param_hmac = content_hmac.split(";v=")[1]
          unless param_hmac
            return false
          end

          hmac = self::calc_hmac(message_body)
          unless hmac
            return false
          end

          hmac == param_hmac
        end
        module_function :check_message?

        #
        # ===設定ファイルの秘密鍵を用いてメッセージのダイジェストを取得します。
        # @param:: message_body メッセージ
        # @return:: ダイジェスト
        # 
        def calc_hmac(message_body)
          merchant_secret_key = MdkConfig.instance.merchant_secret_key
          key = [merchant_secret_key].pack("H*")
          OpenSSL::HMAC::hexdigest(OpenSSL::Digest::SHA256.new, key, message_body)
        end
        module_function :calc_hmac
        private :calc_hmac

        #
        # ===キー、値、マーチャントCC IDのダイジェストを取得します。
        # @param:: value 値
        # @param:: key キー
        # @return:: ダイジェスト
        # 
        def sign(value, key)
          if value.nil? or value.empty?
            return nil #return false
          end

          if key.nil? or key.empty?
            return nil #return false
          end

          merchant_cc_id = MdkConfig.instance.merchant_cc_id
          message = [merchant_cc_id, key, value].join(':')

          OpenSSL::Digest::Digest.hexdigest('sha1', message)
        end
        module_function :sign


        #
        # ===キーと値のダイジェストを検証します。
        # @param:: value 値
        # @param:: key キー
        # @param:: original_digest 取得済みダイジェスト
        # @return:: true: 検証成功、 false： 検証失敗
        # 
        def verify_sign(value, key, original_digest)
          if original_digest.nil? or original_digest.empty?
            return false
          end

          digest = self::sign(value, key)
          digest == original_digest
        end
        module_function :verify_sign

        #
        # ===マーチャントデータ（MD）を生成します。
        # @param:: user_hash_data　マーチャントデータ生成用のユーザ定義のキーと値[Hash]
        # @return:: マーチャントデータ
        # 
        def create_merchant_data(user_hash_data={})
          unless user_hash_data.is_a? Hash
            raise ArgumentError
          end

          str_md = user_hash_data.reject {|key, value|
            key.nil? or key.to_s.empty?

          }.inject([]) {|amd, (key, value)|
            key = ":" + key.to_s if key.is_a? Symbol
            amd << [CGI.escape(key), CGI.escape(value ? value : "")].join('=')

          }.join('&')

          merchant_secret_key = MdkConfig.instance.merchant_secret_key
          digest = self::sign(str_md, merchant_secret_key)

          str_md = str_md.empty? ? digest : [digest, str_md].join('&')

          [str_md].pack('m').gsub(/\n/, '')
        end
        module_function :create_merchant_data


        #
        # ===マーチャントデータ（MD）をユーザ定義のキーと値[Hash]に戻します。
        # @param:: merchant_data マーチャントデータ
        # @return:: ユーザ定義のキーと値[Hash]
        #           検証エラー時は、nil
        # 
        def analyze_merchant_data(merchant_data)
          unless merchant_data.is_a? String
            raise ArgumentError
          end

          dec_md = merchant_data.unpack('m').first  # Base64 decode
          matchdata = dec_md.match(/(^.+?)&(.*$)/).to_a  # 最初の'&'で分割する
          org_digest = matchdata[1]
          source = matchdata[2] ? matchdata[2] : ""


          # 検証
          merchant_secret_key = MdkConfig.instance.merchant_secret_key
          unless verify_sign(source, merchant_secret_key, org_digest)
            return nil
          end

          # 戻りのHashを生成
          source.split('&').inject({}) do |result, kv|
            key, value = kv.split('=')
            next if key.empty?

            key = CGI.unescape(key)
            value = CGI.unescape(value)

            key = key[1, key.size-1].intern if key[0].chr == ':'
            result[key] = value
            result
          end
        end
        module_function :analyze_merchant_data

      end
    end
  end
end

