unless defined?(Veritrans)
  raise "oooooooooooooooooooooooo"
end

module Veritrans
  module Tercerog
    module Mdk
      class MdkTransaction
        unless Rails.env.production? || Rails.env.staging?
          p '##### REPLACE Veritrans::Tercerog::Mdk::MdkTransaction.execute with DUMMY CODE #####'
          def execute(request_dto)
            Mdk::logger.debug("Dummy MdkTransaction.execute() start")
            # コンフィグファイルの設定内容チェック
            MdkConfig.instance.valid?
            if MdkConfig.instance.mdk_error_mode == "1"
              Mdk::logger.debug("mdk erorr mode is on");
              raise MdkError, MdkMessage::MA99_SYSTEM_INTERNAL_ERROR
            end
            # Requestに対応するResponseを取得する
            response_dto = get_response_dto(request_dto)
            response_dto.mstatus = PaymentVeritransTxn::Status::SUCCESS
            Mdk::logger.debug("Dummy MdkTransaction.execute() end")
            response_dto
          end
        end
      end
    end
  end
end
