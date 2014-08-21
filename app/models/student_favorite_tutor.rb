class StudentFavoriteTutor < ActiveRecord::Base
  belongs_to :student
  belongs_to :tutor, :counter_cache => true
  # attr_accessible :title, :body
end
