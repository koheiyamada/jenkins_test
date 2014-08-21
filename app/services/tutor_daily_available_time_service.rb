class TutorDailyAvailableTimeService
  include Loggable

  class << self
    def convert_attributes(attributes)
      {
        start_at: Time.at(attributes[:start_at] / 1000),
        end_at: Time.at(attributes[:end_at] / 1000)
      }
    end
  end

  def initialize(tutor)
    @tutor = tutor
    @error_messages = []
  end

  attr_reader :tutor, :error_messages

  def bulk_update_and_notify(params)
    success = bulk_update(params)
    if success
      tutor.on_daily_available_times_updated
    end
    success
  end

  def bulk_update(params)
    TutorDailyAvailableTime.transaction do
      deletes = params[:delete]
      if deletes.present?
        ids = params[:delete].map{|idx, attrs| attrs[:id]}
        tutor.daily_available_times.where(id: ids).find_each do |item|
          item.destroy
        end
      end

      adds = params[:add]
      if adds.present?
        adds.map do |idx, js_attrs|
          attributes = TutorDailyAvailableTime.to_model_attributes(js_attrs)
          tutor.daily_available_times.create!(attributes)
        end
      end
    end
    true
  rescue Exception => e
    logger.error e
    @error_messages = [e.message]
    false
  end

  private

    def convert_attributes(attributes)
      {
        start_at: Time.at(attributes[:start_at] / 1000),
        end_at: Time.at(attributes[:end_at] / 1000)
      }
    end
end