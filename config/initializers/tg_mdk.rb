# -*- encoding: utf-8 -*-
require 'tgMdkRuby/tgMdk/lib/tg_mdk'

settings_file = File.join(Rails.root, 'config', 'tg_mdk.yml')
settings = YAML.load(File.open(settings_file))[Rails.env]

mdk_config = Veritrans::Tercerog::Mdk::MdkConfig.instance
{
  'CA_CERT_FILE' => File.join(Rails.root, 'lib', 'tgMdkRuby', 'resources', 'cert.pem'),
  'MDK_ERROR_MODE' => 0,
  'DUMMY_REQUEST' => settings['dummy_request'],
  'MERCHANT_CC_ID' => settings['merchant_cc_id'],
  'MERCHANT_SECRET_KEY' => settings['merchant_secret_key'],
}.each do |k, v|
  mdk_config.overwrite(k, v.to_s)
end
