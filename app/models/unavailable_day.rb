class UnavailableDay < ActiveRecord::Base
  belongs_to :tutor
  attr_accessible :date

  scope :future, lambda{where("date >= :d", d:Date.today)}

  validates_uniqueness_of :date, :scope => :tutor_id

  after_create do
    # チューターの予定を更新する
    if tutor
      tutor.update_available_times
    end
  end

  after_destroy do
    # チューターの予定を更新する
    if tutor
      tutor.update_available_times
    end
  end
end
