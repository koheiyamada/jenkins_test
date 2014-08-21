module SubjectLevelsHelper
  def subject_level_name(subject_level)
    if subject_level.blank?
      nil
    else
      t("subject_level.codes.#{subject_level.code}")
    end
  end
end