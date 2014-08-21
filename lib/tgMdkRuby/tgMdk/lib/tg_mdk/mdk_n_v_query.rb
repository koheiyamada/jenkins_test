# -*- encoding: utf-8 -*-
#= mdk_n_v_query.rb - 3GPS MDK Library Name and Value 構築用クラス
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
      # MdkNVQuery クラス
      #    リクエストDTOから取得するN=V文字列の生成を管理するクラス
      #
      class MdkNVQuery

        # N=V要素結合文字
        PARAM_UNITE_CHAR = "&"
        # マスクN=V要素結合文字
        MASK_PARAM_UNITE_CHAR = "   "
        # N=V要素結合文字エスケープ文字列
        PARAM_UNITE_CHAR_ESCAPE = "\\\\&"
        # ダブルクオート
        DQUOTE_CHAR = "\""
        # ダブルクオートエスケープ文字列
        DQUOTE_CHAR_ESCAPE = "\\\""
        # N、V結合文字
        NV_UNITE_CHAR = "="
        # マスクN、V結合文字
        MASK_NV_UNITE_CHAR = ":"
        # マスク文字列
        MASKED_VALUE = "******"
        # サービス固有要素前置詞
        EXPARAM_PREPOSIT = "exparam"
        # 特殊マスク項目：カード番号
        ITEM_CARDNUMBER = "CARDNUMBER"
        # NAME部階層区切り文字
        N_SEP = "."

        #
        # ===コンストラクタ
        # コンフィグファイルからデータを取得して当クラスを使用できる状態にする。
        # @param:: dto 処理対象Dto
        #
        def initialize(dto)
          # コンフィグクラス生成
          config = Veritrans::Tercerog::Mdk::MdkConfig.instance

          # インスタンス変数初期化
          @common_item_list = config[MdkConfig::COMMON_ITEM].split(",")
          # 大文字化して取得
          @mask_item_list = config[MdkConfig::MASK_ITEM].upcase.split(",")
          @nv_list = []
          @name_value = ""
          @masked_name_value = ""

          # DTOの文字エンコードを取得
          @encode = config[MdkConfig::DTO_ENCODE]

          # N=V リスト設定
          get_nv_of_dto(dto)

          # N=V文字列、マスクN=V文字列作成
          unite_char = ""
          @nv_list.each do |item|
            enc_value = enc_conv(item[1]);
            @name_value = @name_value + unite_char + item[0] + NV_UNITE_CHAR + enc_value
            @masked_name_value = @masked_name_value + item[0] + MASK_NV_UNITE_CHAR + mask_value(item[0], enc_value) + MASK_PARAM_UNITE_CHAR
            unite_char = PARAM_UNITE_CHAR
          end
        end

        #
        # ===N=V連結文字を取得する
        # @return:: N=V連結文字
        #
        def name_value
          @name_value
        end

        #
        # ===マスクされたN=V連結文字を取得する
        # @return:: マスクされたN=V連結文字
        #
        def masked_name_value
          @masked_name_value
        end

        #
        # ===設定値のエスケープ処理を行う
        # @param:: value 設定値
        # @return:: エスケープ処理後の設定値
        #
        def value_escape(value)
          value = value.gsub(PARAM_UNITE_CHAR, PARAM_UNITE_CHAR_ESCAPE)
          value = value.gsub(DQUOTE_CHAR, DQUOTE_CHAR_ESCAPE)
        end
        private :value_escape

        #
        # ===MDKで使用されている文字のUTF-8エンコードをマーチャントが指定するエンコードに変更する
        # @param:: value 設定値
        #
        def enc_conv(value)
          # 指定されている場合は指定のエンコードに変換
          if (@encode != nil && 0 < @encode.length && @encode.upcase != "UTF-8")
            # エンコードが指定されている場合
            return Iconv.conv('UTF-8', @encode, value)
          else
            return value
          end
        end

        #
        # ===設定値のマスク化を行う
        # @param:: name 項目名
        # @param:: value 設定値
        # @return:: マスク処理後の設定値
        #
        def mask_value(name, value)
          # Name部の最終項目名を抜き出す
          start_index = 0
          end_index = 0
          start_index = name.rindex(".") + 1 if name.rindex(".")
          end_index = name.rindex("[") - 1 if name.rindex("[")
          if end_index == nil or end_index <= start_index
            end_index = name.length - 1
          end
          last_name = name[start_index..end_index].upcase

          # 項目名がマスク化項目リストに含まれる場合はマスク化を行う
          if @mask_item_list.index(last_name)
            return value[0, 4] + MASKED_VALUE + MASKED_VALUE if last_name == ITEM_CARDNUMBER
            return MASKED_VALUE
          end
          value
        end
        private :mask_value

        #
        # ===Dtoに設定されたパラメータを取得しN=V文字列を生成する
        # @param:: dto 処理対象Dto
        # @param:: name_string 階層文字列
        # @return:: N=V文字列
        #
        def get_nv_of_dto(dto, name_string="")
          # DTOのインスタンス変数を取得

          dto.instance_variables.each do |name|
            # BASE_DTOを継承したオブジェクトで共通項目の場合、サービス固有要素前置詞を設定
            name = name.to_s # for ruby 1.9
            if @common_item_list.index(name.mdk_camelize[1, name.length - 1]) == nil and dto.kind_of? RequestBaseDto
              exparam_string = EXPARAM_PREPOSIT + N_SEP
            else
              exparam_string = ""
            end

            # インスタンス変数の値を取得
            value = dto.instance_variable_get(name)

            # N=Vリストに対象インスタンス変数のN=Vを追加する
            create_name_value_string(name, value, exparam_string, name_string)
          end
        end
        private :get_nv_of_dto
        
        #
        # ===N=V文字列を生成する
        # @param:: name 項目名
        # @param:: value 項目値
        # @param:: exparam_string 階層文字列(exparam)
        # @param:: name_string 階層文字列
        # @return:: N=V文字列
        #
        def create_name_value_string(name, value, exparam_string, name_string)
          if "".instance_of?(value.class) # 設定値が文字列
            return if value.empty?
            # N=V文字列作成
            @nv_list << [name_string + exparam_string + name.mdk_camelize[1, name.length - 1], value_escape(value)]
          elsif value.instance_variables.size > 0 # 設定値がオブジェクト
            # Name階層文字列を作成
            name_string = name_string + exparam_string + name.mdk_camelize[1, name.length - 1] + N_SEP
            # 再帰呼出し
            get_nv_of_dto(value, name_string)
          elsif [].instance_of?(value.class) # 設定値が配列
            value.each_with_index do |element, count|
              if "".instance_of?(element.class) # 要素が文字列
                return if value.empty?
                # N=V文字列作成
                @nv_list << [name_string + exparam_string + name.mdk_camelize[1, name.length - 1] + "[" + count.to_s + "]", value_escape(element)]
              elsif element.instance_variables.size > 0 # 要素がオブジェクト
                # Name階層文字列を作成
                name_string = name_string + exparam_string + name.mdk_camelize[1, name.length - 1] + "[" + count.to_s + "]" + N_SEP
                # 再帰呼出し
                get_nv_of_dto(element, name_string)
              end
            end
          else # 判定できない無効なクラスが指定されている
            mess = "#{name} is invalid type '#{value.class.name}'"
            Mdk::logger.error(mess)
            t = name.to_s
            raise MdkError.new(MdkMessage::MA07_INVALID_DTO_VALUE_TYPE, t[1, t.length - 1], value.class.name)
          end
        end
        private :create_name_value_string

      end
    end
  end
end

