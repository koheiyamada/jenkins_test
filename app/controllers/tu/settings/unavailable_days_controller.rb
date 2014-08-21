class Tu::Settings::UnavailableDaysController < ApplicationController
  tutor_only
  layout 'with_sidebar'

  def index
    @unavailable_days = current_user.unavailable_days.future.order("date")
  end

  def create
    date = Date.parse(params[:date])
    @unavailable_day = UnavailableDay.new(date:date)
    @unavailable_day.tutor = current_user
    respond_to do |format|
      format.json do
        @unavailable_day.save!
        render json:@unavailable_day
      end
      format.html do
        if @unavailable_day.save
          redirect_to action:"index"
        else
          if @unavailable_day.errors.any?
            logger.warn(@unavailable_day.errors.full_messages.join(", "))
          end
          redirect_to action:"index"
        end
      end
    end
  end

  def destroy
    @unavailable_day = current_user.unavailable_days.find(params[:id])
    @unavailable_day.destroy
    redirect_to action:"index"
  end
end
