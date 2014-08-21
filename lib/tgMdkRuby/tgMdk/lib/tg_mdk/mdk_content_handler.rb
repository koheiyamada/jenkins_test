# -*- encoding: utf-8 -*-
#= mdk_content_handler.rb - 3GPS MDK Library レスポンスDTOマッピングクラス
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

#begin
#  require 'xmlsimple'
#rescue LoadError
#  require 'rubygems'
#  require 'xmlsimple'
#end
begin
  require 'xml/libxml'

  #require 'xmlsimple'
rescue LoadError
  require 'rubygems'
  require 'xml/libxml'

  #require 'xmlsimple'
end


module Veritrans
  module Tercerog
    module Mdk
      #
      # MdkContentHandler クラス
      #    3GPSの戻り電文（XML）からレスポンスDTOへプロパティをマッピングするクラス
      #
      class MdkContentHandler

        # 決済コマンド共通部ルートエレメント
        ELEM_DTO_ROOT = "GWPaymentResponseDto"
        # 決済コマンド共通部ルートエレメント
        ELEM_RESULT_ROOT = "result"
        # 決済コマンド固有部ルートエレメント
        ELEM_EXRESULT_ROOT = "exresult"
        # オプション部ルートエレメント
        ELEM_OPTIONS_ROOT = "optionResults"

        #
        # ===コンストラクタ
        #
        def initialize()
          config = Veritrans::Tercerog::Mdk::MdkConfig.instance
          # DTOの文字エンコードを取得
          @encode = config[MdkConfig::DTO_ENCODE]
        end

        #
        # ===GW処理結果XMLを応答Dtoの各プロパティに設定する
        # @param:: result_xml_string XML文字列
        # @param:: response_dto 応答Dto
        # @return:: XMLを設定した応答Dto
        #
        def exec(result_xml_string, response_dto)
          #XML情報取得
          xml = from_libxml(result_xml_string)

          #決済固有部情報取得
          if(xml[ELEM_DTO_ROOT][ELEM_RESULT_ROOT][0][ELEM_EXRESULT_ROOT])
            elms_exresult = xml[ELEM_DTO_ROOT][ELEM_RESULT_ROOT][0][ELEM_EXRESULT_ROOT][0]
            # Dtoプロパティ設定
            parse_xml(elms_exresult, response_dto)
          end

          # 決済共通部情報取得
          elms_result = xml[ELEM_DTO_ROOT][ELEM_RESULT_ROOT][0]
          # optionResults情報を削除
          elms_result.delete(ELEM_OPTIONS_ROOT)
          # exresult情報を削除
          elms_result.delete(ELEM_EXRESULT_ROOT)
          # Dtoプロパティ設定
          parse_xml(elms_result, response_dto)

          response_dto #return
        end

        #
        # ===XMLをDtoの各プロパティに設定する
        # @param:: nodes ノード配列
        # @param:: response_dto 応答Dto
        #
        def parse_xml(nodes, response_dto)
          nodes.keys.each do |key|
            # Element名よりgetter名/setter名生成
            getter_name = key.gsub(/\b\w/){|word| word.downcase}.gsub(/[A-Z]/){|word|
                     "_".concat word.downcase}
            setter_name = key.gsub(/\b\w/){|word| word.downcase}.gsub(/[A-Z]/){|word|
                             "_".concat word.downcase}
            setter_name = setter_name.concat "="

            # インスタンス変数の存在確認
            if response_dto.respond_to?(setter_name)
              # DTOのインスタンス変数のクラスによって処理を変更
              value = response_dto.send(getter_name)
              if [].instance_of?(value.class)
                if Veritrans::Tercerog::Mdk::BaseDto.new.instance_of?(value[0].class)
                  instance_list = []
                  # XMLからオブジェクト配列を作成
                  nodes[key].each do |child_nodes|
                    if child_nodes.size > 0
                      instance = eval(key.gsub(/^\w/){|word| word.upcase}).new
                      # 処理中ノードとDtoクラスを基に再帰処理を実行
                      parse_xml(child_nodes, instance)
                      instance_list << instance
                    end
                  end
                  # オブジェクト配列をDTOプロパティに設定
                  response_dto.send(setter_name, instance_list)
                else
                  # 文字列配列をDTOプロパティに設定
                  nodes[key] = [""] unless "".instance_of?(nodes[key][0].class)
                  response_dto.send(setter_name, enc_conv(nodes[key]))
                end
              elsif Veritrans::Tercerog::Mdk::BaseDto.new.instance_of?(value.class)
                if nodes[key][0].size > 0
                  instance = eval(key.gsub(/^\w/){|word| word.upcase}).new
                  # 処理中ノードとDtoクラスを基に再帰処理を実行
                  parse_xml(nodes[key][0], instance)
                  # オブジェクトをDTOプロパティに設定
                  response_dto.send(setter_name, instance)
                end
              else
                # 文字列をDTOプロパティに設定
                nodes[key][0] = "" unless "".instance_of?(nodes[key][0].class)
                response_dto.send(setter_name, enc_conv(nodes[key][0]))
              end
            else
              # パースするプロパティが無かったエレメント要素の存在をログ出力
              Mdk::logger.info("method:'".concat getter_name.concat "' not exists!!!!! ".concat nodes[key].to_s)
            end
          end

          # 初期値 消去処理
          response_dto.instance_variables.each do |name|
            # インスタンス変数の値を取得
            value = response_dto.instance_variable_get(name)
            if [].instance_of?(value.class)
              if Veritrans::Tercerog::Mdk::BaseDto.new.instance_of?(value[0].class)
                response_dto.instance_variable_set(name, [])
              end
            elsif Veritrans::Tercerog::Mdk::BaseDto.new.instance_of?(value.class)
                response_dto.instance_variable_set(name, nil)
            end
          end
        end



        def from_libxml(xml, strict=true)
          begin
            XML.default_load_external_dtd = false
            XML.default_pedantic_parser = strict
            doc = XML::Parser.string(xml).parse
            return { doc.root.name.to_s => xml_node_to_hash(doc.root)}
          rescue Exception => e
                # raise your custom exception here
          end
        end

        def xml_node_to_hash(node)
          if node.element?
           if node.children?
              result_hash = {}

              node.each_child do |child|
                result = xml_node_to_hash(child)

                if child.name == "text"
                  if !child.next? and !child.prev?
                    return result
                  end
                elsif result_hash[child.name.to_s]
                    if result_hash[child.name.to_s].is_a?(Object::Array)
                      result_hash[child.name.to_s] << result
                    else
                      result_hash[child.name.to_s] = [result_hash[child.name.to_s]] << result
                    end
                  else
                    result_hash[child.name.to_s] = [result]
                  end
                end

              return result_hash
            else
              return {}
           end
           else
            return node.content.to_s
          end
        end

        #
        # ===MDKで使用されている文字のUTF-8エンコードをマーチャントが指定するエンコードに変更する
        # @param:: value 設定値
        #
        def enc_conv(value)
          # 指定されている場合は指定のエンコードに変換
          if (@encode != nil && 0 < @encode.length && @encode.upcase != "UTF-8")
            # エンコードが指定されている場合
            return Iconv.conv(@encode, 'UTF-8', value)
          else
            return value
          end
        end

      end
    end
  end
end