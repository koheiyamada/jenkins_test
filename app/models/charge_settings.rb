class ChargeSettings < ActiveRecord::Base
  attr_accessible :amount, :name

  validates_presence_of :amount, :name
  validates_numericality_of :amount, :only_integer => true, :greater_than_or_equal_to => 0

  class << self
    # 各設定値を返すメソッドを作成する
    # entry_feeなど
    names = YAML.load_file(Rails.root.join('db/data/charge_settings.yml'))
    names.keys.each do |key|
      define_method key do
        setting = find_by_name(key)
        if setting
          setting.amount
        else
          logger.error("Charge settings for #{key} does not exist.")
          raise key
        end
      end
    end

    def hidden?(charge_setting)
      hidden_items.include? charge_setting.name
    end

    private

      def hidden_items
        @hidden_items ||=
          %w(soba_id_management_fee textbook_usage_fee tutor_referral_fee textbook_rental_fee bs_textbook_rental_fee)
      end
  end

  def display_name
    I18n.t("charge_settings.names.#{name}")
  end
end
