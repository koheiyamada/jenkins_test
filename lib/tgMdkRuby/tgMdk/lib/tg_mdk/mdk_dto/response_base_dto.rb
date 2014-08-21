# -*- encoding: utf-8 -*-
require 'tg_mdk/mdk_dto/base_dto'

include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk
      class ResponseBaseDto < ::BaseDto
        #
        # TradURLを取得するXPath
        #
        TRAD_URL_XPATH = "/GWPaymentResponseDto/result/optionResults/TradResult/url";
      end
    end
  end
end
