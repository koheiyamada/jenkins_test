## -*- encoding: utf-8 -*-
#= mdk_transaction.rb - 3GPS MDK Library トランザクションクラス
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
      # MdkNilResponseDtoクラス
      #       システムエラー時のNilレスポンス用クラス
      #
      class MdkNilResponseDto
        def method_missing(method_name, *args)
          {:v_result_code => MdkMessage::MA99_SYSTEM_INTERNAL_ERROR,
            :mstatus => "failure",
            :merr_msg => MdkMessage.instance.get_message(MdkMessage::MA99_SYSTEM_INTERNAL_ERROR)
          }[method_name]
        end
      end

      #
      # MdkTransactionクラス
      #       VeriTrans 3GPS 通信制御クラス
      #
      class MdkTransaction

        #
        # ===コンストラクタ
        # @param:: logger ログ出力用クラス
        #          未指定の場合は、Mdk用デフォルトロガークラスを使用します。
        #
        def initialize(logger=nil)
          unless logger
            logger = MdkLogger.new(self.class.name)
            logger.trace = true
          end
          Mdk.const_set("MDK_DEFAULT_LOGGER", logger) unless
            Mdk.constants.include?("MDK_DEFAULT_LOGGER")
        end


        #
        # ===VeriTrans 3GPSとの通信を実行します。
        # @param:: request_dto リクエストに利用するDTOクラス
        # @return:: リクエストに対応するレスポンスDTOクラス
        #           対応するレスポンスが取得できない場合、Nilレスポンスクラスのインスタンスを返却します。
        #
        def execute(request_dto)
          Mdk::logger.debug("MdkTransaction.execute() start")

          # コンフィグファイルの設定内容チェック
          MdkConfig.instance.valid?

          if MdkConfig.instance.mdk_error_mode == "1"
            Mdk::logger.debug("mdk erorr mode is on");
            raise MdkError, MdkMessage::MA99_SYSTEM_INTERNAL_ERROR
          end

          # Requestに対応するResponseを取得する
          response_dto = get_response_dto(request_dto)

          # MdkNVQuery作成
          nv_query = MdkNVQuery.new(request_dto)

          # ログ出力用文字列（マスク化N=V)を設定
          request_dto._set_masked_log = nv_query.masked_name_value
          
          # 接続先の情報と送信するデータ内容をログ出力
          Mdk::logger.debug("request mct data ==> " + nv_query.masked_name_value)

          # 実行時パラメータを付加
          plain_nv_text = [
            nv_query.name_value,
            nv_param(nv_query.name_value)
          ].join('&')

          # URL SAFE Base64
          b64enc_nv_text = MdkUtils::mdk_base64_encode(plain_nv_text)

          # リクエスト用文字列
          request_string = "3gpsBody=#{b64enc_nv_text}"
          
          # 通信処理
          con = MdkConnection.new
          response_xml = con.execute(request_string)

          # 結果マッピング処理
          content_handler = MdkContentHandler.new
          content_handler.exec(response_xml, response_dto)

          # XMLのマスク処理と設定
          mask_response_xml = MdkUtils::mdk_mask_xml(response_xml)
          response_dto._set_result_xml = mask_response_xml

          Mdk::logger.debug("response xml ==> " + MdkUtils::mdk_delete_r_n(mask_response_xml))

        rescue => e
          if e.is_a? MdkError
            if Mdk::logger
              Mdk::logger.error(e)
              Mdk::logger.error(e.backtrace.join("\n"))
            end
          else
            if Mdk::logger
              Mdk::logger.fatal(e)
              Mdk::logger.fatal(e.backtrace.join("\n"))
            end
          end
          Mdk::logger.debug("MdkTransaction.execute() end")
          response_dto = get_error_response_dto(request_dto, e)

        else
          Mdk::logger.debug("MdkTransaction.execute() end")
          response_dto
        end

        #
        # ===N=V文字列から、実行時パラメータを付加した通信用の文字列を生成します。
        # @param:: name_and_value パラメータと値のN=V文字列 
        # @return:: 実行時パラメータを付加した通信用の文字列
        #
       def nv_param(name_and_value)
          conf = MdkConfig.instance

          # NV情報文字列の追加
          other_param =
            [
              "txnVersion=#{conf.mdk_dto_version}",
              "dummyRequest=#{conf.dummy_request}",
              "requestDatetimeGMT=#{MdkUtils::mdk_gmtime}",
              "merchantCcid=#{conf.merchant_cc_id}"
            ].join('&')

          # 接続先の情報と送信するデータ内容をログ出力
          Mdk::logger.debug("request mdk data ==> " + other_param)

          data = 
            [ conf.merchant_cc_id,
              name_and_value,
              '&',
              other_param,
              conf.merchant_secret_key ].join

          digest = MdkUtils::mdk_digest(data)

          other_param += "&authHash=#{digest}"
        end
        private :nv_param

        #
        # ===リクエストDTOに対応するレスポンスDTOを取得します。
        # @param:: request_dto レスポンス取得対象となるリクエストDTO
        # @return:: レスポンスDTO
        #
        def get_response_dto(request_dto)
          if request_dto.nil?
            return nil
          end

          tmp = request_dto.class.name.dup
          res_dto_name = tmp.sub!(/RequestDto$/, "ResponseDto")
          unless res_dto_name
            raise MdkError, MdkMessage::MA99_SYSTEM_INTERNAL_ERROR
          end

          response_dto = nil
          res_dto_class = res_dto_name.split(/::/).inject(Object) do |obj, name|
            obj.const_get(name)
          end
          response_dto = res_dto_class.new

        rescue => e
          raise e
        else
          response_dto
        end
        private :get_response_dto


        #
        # ===エラー発生時のレスポンス用DTOを取得します。
        # @param:: request_dto レスポンス取得対象となるリクエストDTO
        # @param:: e レスポンスDTOに設定するエラーを保持する例外クラス 
        # @return:: エラー用レスポンスDTO
        #           メソッド内でエラーが発生した場合は、NilレスポンスDTO [MdkNilResponseDto] を返却します。
        #
        def get_error_response_dto(request_dto, e)
          response_dto = get_response_dto(request_dto)
          response_dto.v_result_code = MdkMessage::MA99_SYSTEM_INTERNAL_ERROR
          response_dto.mstatus = "failure"
          response_dto.merr_msg = e.message
          if e.is_a? MdkError
            response_dto.v_result_code = e.v_result_code
          end

        rescue
          response_dto = MdkNilResponseDto.new
        else
          response_dto
        end
        private :get_error_response_dto

      end
    end
  end
end

