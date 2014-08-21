module PcSpecHolder
  def self.included(base)
    base.validates_numericality_of :windows_experience_index_score, :allow_blank => true
    base.validates_numericality_of :upload_speed, :allow_blank => true
    base.validates_numericality_of :download_speed, :allow_blank => true
    base.validates_presence_of :os_id

    base.attr_accessible :os_id, :adsl, :upload_speed, :download_speed, :windows_experience_index_score
  end
end