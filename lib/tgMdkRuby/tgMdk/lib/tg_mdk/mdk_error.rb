# -*- encoding: utf-8 -*-
#= mdk_error.rb - 3GPS MDK Library アプリケーション例外クラス
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
      # MdkError クラス
      #    Mdk内部で使用するアプリケーション例外クラス
      #
      class MdkError < StandardError

        #
        # ===コンストラクタ
        # @param:: エラーメッセージもしくは、メッセージ[MdkMessage]のキー
        #
        def initialize(*argv)
          @code = MdkMessage::MA99_SYSTEM_INTERNAL_ERROR

          unless argv.empty?
            const_def = false
            MdkMessage.constants.each do |const|
              if MdkMessage.const_get(const) == argv.first
                const_def = true
                break
              end
            end

            if const_def
              @code = argv.shift
              @msg = MdkMessage.instance.get_message(@code, *argv)
              argv.clear
              argv.unshift(@msg)
            else
              @msg = *argv
            end

          end

          super(*argv)
        end

        # 
        # ===例外に対応するリザルトコードを取得します。
        # @return:: 16桁のvResultCode
        # 
        def v_result_code
          @code + "0" * 12
        end

        # 
        # ===例外に対応するエラーメッセージを取得します。
        # @return:: エラーメッセージ
        # 
        def message
          super
        end

      end
    end
  end
end
