class Counter < ActiveRecord::Base
  class << self
    def next(key)
      find_or_create_by_key(key).next
    end
  end

  attr_accessible :count, :key

  validates_presence_of :key, :count
  validates_uniqueness_of :key

  def next
    with_lock do
      increment! :count
      count
    end
  end
end
