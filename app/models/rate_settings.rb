class RateSettings < ActiveRecord::Base
  attr_accessible :name, :rate

  class << self
    YAML.load_file(Rails.root.join('db/data/rate_settings.yml')).keys.each do |name|
      define_method name do
        find_by_name(name).rate
      end
    end
  end

  validates_presence_of :name, :rate
end
