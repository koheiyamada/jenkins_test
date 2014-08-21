class LessonMaterial < ActiveRecord::Base
  mount_uploader :material, LessonMaterialUploader

  class << self
    def owned_by(user)
      where(user_id:user.id)
    end
  end

  belongs_to :owner, class_name:User.name, :foreign_key => :user_id
  belongs_to :lesson

  attr_accessible :lesson, :user, :material

  validates_presence_of :lesson_id, :user_id, :material

  def url
    material && material.url
  end

  def file_path
    material && material.current_path
  end
end
