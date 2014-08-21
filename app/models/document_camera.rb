class DocumentCamera < ActiveRecord::Base
  class << self
    def created_on(date)
      where(created_at: date.to_time.all_day)
    end

    def of_month(month)
      where(created_at: month.to_time.all_month)
    end

    def of_year(year)
      where(created_at: Date.new(year).to_time.all_year)
    end
  end

  belongs_to :user

  attr_accessible :user

  validates_presence_of :user_id

  def date
    created_at.to_date
  end
end
