module TutorSearchable
  private

    def tutor_search_options
      options = {active: true}
      options[:sex] = params[:sex] if params[:sex].present?
      options[:subject_ids] = [params[:subject_id].to_i] if params[:subject_id].present?
      options[:weekdays] = [params[:wday].to_i] if params[:wday].present?
      options[:undertake_group_lesson] = params[:undertake_group_lesson] == '1' if params[:undertake_group_lesson].present?
      options
    end
end