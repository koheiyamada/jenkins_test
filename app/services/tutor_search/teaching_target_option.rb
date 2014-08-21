# coding:utf-8

class TutorSearch

  #
  # 指導対象選択
  # 検索パラメータに:grade, :subject_id, :levelが含まれる場合に
  # 検索対象となるチューターを絞り込む。
  # :gradeがなければ何もしない。
  # :subject_idと:levelはオプション。
  #
  class TeachingTargetOption
    def initialize(params)
      if params[:grade].present?
        @grade_id = params[:grade].to_i
        if params[:subject_id].present?
          @subject_id = params[:subject_id].to_i
          if params[:level].present?
            @level = params[:level].to_i
          end
        end
      end
    end

    attr_reader :grade_id, :subject_id, :level

    def has_options?
      @grade_id.present? || @subject_id.present? || @level.present?
    end

    def tutor_ids
      teaching_subjects = TeachingSubject.scoped
      if grade_id
        grade_group = grade.group
        teaching_subjects = teaching_subjects.where(grade_group_id: grade_group.id)
        if subject_id
          teaching_subjects = teaching_subjects.where(subject_id: subject_id)
          if level
            teaching_subjects = teaching_subjects.where(level: level)
          end
        end
      end
      Tutor.only_active.where(id: teaching_subjects.pluck(:tutor_id)).pluck(:id)
    end

    def grade
      @grade ||= Grade.find(grade_id)
    end

    def subjects
      grade && grade.subjects
    end
  end
end