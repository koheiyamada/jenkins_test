## -*- encoding: utf-8 -*-
class TutorSearch
  include Loggable

  class << self
    def per_page
      25
    end

    def default_fields(*fields)
      if fields.empty?
        @default_fields || []
      else
        @default_fields = fields
      end
    end

    def sort_keys
      if SystemSettings.cs_point_visible?
        [
          [I18n.t('tutor_search.sort_keys.cs_points'), :cs_points],
          [I18n.t('tutor_search.sort_keys.average_cs_points'), :average_cs_points],
          [I18n.t('tutor_search.sort_keys.lesson_fee'), :lesson_fee],
          [I18n.t('tutor_search.sort_keys.career_length'), :career_length],
          [I18n.t('tutor_search.sort_keys.lesson_units'), :lesson_units],
          [I18n.t('tutor_search.sort_keys.cancellation_count'), :cancellation_count],
        ]
      else
        [
          [I18n.t('tutor_search.sort_keys.lesson_fee'), :lesson_fee],
          [I18n.t('tutor_search.sort_keys.career_length'), :career_length],
          [I18n.t('tutor_search.sort_keys.cancellation_count'), :cancellation_count],
        ]
      end
    end

    def full_sort_keys
      [
          [I18n.t('tutor_search.sort_keys.cs_points'), :cs_points],
          [I18n.t('tutor_search.sort_keys.average_cs_points'), :average_cs_points],
          [I18n.t('tutor_search.sort_keys.lesson_fee'), :lesson_fee],
          [I18n.t('tutor_search.sort_keys.career_length'), :career_length],
          [I18n.t('tutor_search.sort_keys.lesson_units'), :lesson_units],
          [I18n.t('tutor_search.sort_keys.cancellation_count'), :cancellation_count],
      ]
    end
  end

  default_fields :user_name, :full_name, :full_name_kana,
                 :address, :hometown_address,
                 :nickname,
                 :college, :department, :faculty,
                 :graduate_college, :graduate_college_department, :major,
                 :birth_place, :high_school, :hobby,
                 :activities, :teaching_experience, :teaching_results, :free_description,
                 :jyuku_history, :favorite_books,
                 :emails, :skype_id, :phone_number,
                 :pc_model_number,
                 :reference_user_name

  def initialize(params)
    @params = params
    setup_options params
  end

  attr_reader :params

  attr_reader :options, :fields, :key, :min_lesson_fee, :max_lesson_fee,
              :page, :weekday_start_time, :weekday_end_time, :weekday_time_range,
              :teaching_target_option, :sort_keys,
              :original_key,
              :total_count, :total_pages,
              :teaching_time_option

  def execute
    return [] if options[:tutor_id] && options[:tutor_id].empty?
    config = self
    logger.info "TUTOR SEARCH: #{self.as_json}"
    logger.info "TUTOR SEARCH: options: #{options}"
    search = Tutor.search do
      config.options.each do |k, v|
        with k, v
      end

      config.set_lesson_fee_conditions self

      config.sort_keys.each do |sort_key|
        order_by(sort_key.key, sort_key.order)
      end
      fields = config.search_fields
      logger.info "TUTOR SEARCH: fields:#{fields}, detailed:#{detailed_search?}"
      if fields.present?
        fulltext config.key do
          fields(*fields)
        end
      else
        fulltext config.key
      end
      if config.page.present?
        paginate page: config.page, per_page: TutorSearch.per_page
      end
    end
    @total_count = search.total
    search.results
  end

  def set_lesson_fee_conditions(search_scope)
    if max_lesson_fee
      search_scope.with(:base_lesson_fee).less_than max_lesson_fee
    end
    if min_lesson_fee
      search_scope.with(:base_lesson_fee).greater_than min_lesson_fee
    end
  end

  def default_options
    {active: true}
  end

  def default_fields
    self.class.default_fields
  end

  def search_fields
    collect_search_fields.uniq
  end

  def start_time
    @teaching_time_option.start_time
  end

  def end_time
    @teaching_time_option.end_time
  end

  def subjects
    if teaching_target_option
      teaching_target_option.subjects
    end
  end

  def detailed_search?
    options.size > 1 ||
      teaching_target_option.has_options? ||
      has_lesson_fee_options? ||
      has_college_options? ||
      has_graduate_college_options?
  end

  def has_lesson_fee_options?
    max_lesson_fee.present? || min_lesson_fee.present?
  end

  def has_college_options?
    @params[:college].present? || @params[:department].present?
  end

  def has_graduate_college_options?
    @params[:graduate_college].present? || @params[:major].present?
  end

  def has_weekday_schedule_option?
    weekday_start_time || weekday_end_time
  end

  private

    def setup_options(params)
      @original_key = SearchUtils.normalize_key (params[:q] || '')
      @key = @original_key
      @options = default_options
      @page = params[:page] || 1
      @fields = params[:fields] || []
      @teaching_target_option = TeachingTargetOption.new(params)
      @sort_keys = []
      @teaching_time_option = make_teaching_time_option

      setup_search_options params
      setup_lesson_fees params
      setup_college params
      setup_graduate_college params
      setup_sort_keys params

      if @fields.empty?
        @fields = default_fields
      end
    end

    def make_teaching_time_option
      @schedule_option ||= TeachingTimeOption.new(params)
    end

    def setup_search_options(params)
      if params[:sex].present?
        @options[:sex] = params[:sex]
      end

      if params[:subject_id].present?
        @options[:subject_ids] = [params[:subject_id].to_i]
      end

      if params[:wdays].present?
        @options[:weekdays] = params[:wdays].keys.map(&:to_i)
      end

      if params[:undertake_group_lesson].present?
        @options[:undertake_group_lesson] = params[:undertake_group_lesson] == '1'
      end

      if params[:age_group_id].present?
        @options[:age_group_id] = params[:age_group_id].to_i
      end

      if params[:regular_only].present?
        @options[:regular] = true
      end

      if params[:tutor_type].present?
        case params[:tutor_type]
        when 'beginner'
          if @options[:regular]
            params[:tutor_type] = nil # すでに@options[:regular]がtrueの場合はそちらを優先する
          else
            @options[:regular] = false
          end
        when 'regular'
          @options[:regular] = true
        when 'special'
          @options[:special] = true
        else
        end
      end

      setup_graduate_college(params)

      setup_graduated(params)

      setup_tutor_id_option
    end

    def setup_college(params)
      if params[:college].present?
        append_to_keyword params[:college]
        @fields << :college
      end
      if params[:department].present?
        append_to_keyword params[:department]
        @fields << :department
      end
    end

    def setup_nickname(params)
      if params[:nickname].present?
        append_to_keyword params[:nickname]
        @fields << :nickname
      end
    end

    def setup_lesson_fees(params)
      if params[:min_lesson_fee].present?
        @min_lesson_fee = params[:min_lesson_fee].to_i
      end

      if params[:max_lesson_fee].present?
        @max_lesson_fee = params[:max_lesson_fee].to_i
      end
    end

    def setup_graduated(params)
      if params[:graduated].present?
        @options[:graduated] = params[:graduated] == 'true'
      end
    end

    def setup_graduate_college(params)
      if params[:graduate_college].present?
        append_to_keyword params[:graduate_college]
        @fields << :graduate_college
      end
      if params[:major].present?
        append_to_keyword params[:major]
        @fields << :major
      end
    end

    def setup_sort_keys(params)
      if params[:sort_key].present?
        params[:sort_key].each do |i, attrs|
          if attrs[:key].present?
            order = attrs[:order].present? ? attrs[:order] : 'asc'
            key, order = form_key_to_search_key(attrs[:key], order)
            @sort_keys << SortObject.new(key, order)
          end
        end
      end
    end

    def form_key_to_search_key(key, order)
      if key.to_sym == :career_length
        [:created_at, reverse_order(order)]
      else
        [key, order]
      end
    end

    def reverse_order(order)
      order.to_sym == :asc ? :desc : :asc
    end

    def setup_tutor_id_option
      ids1 = teaching_time_option.valid? ? teaching_time_option.tutor_ids : nil
      logger.debug "ids1 = #{ids1}"
      ids2 = teaching_target_option.has_options? ? teaching_target_option.tutor_ids : nil
      logger.debug "ids2 = #{ids2}"
      ids3 = restrict_tutor_ids(ids1, ids2)
      logger.debug "ids3 = #{ids3}"
      unless ids3.nil?
        options[:tutor_id] = (ids3 + tutor_ids_with_no_schedules)
      end
    end

    def append_to_keyword(s)
      if @key.blank?
        @key = s
      else
        @key += ' ' + s
      end
    end

    def restrict_tutor_ids(ids1, ids2)
      if ids1.nil?
        ids2
      elsif ids2.nil?
        ids1
      else
        ids1 & ids2
      end
    end

    def tutor_ids_with_no_schedules
      Tutor.only_active.where(weekday_schedules_count: 0).pluck(:id)
    end

    def collect_search_fields
      if detailed_search?
        if original_key.present?
          (fields || []) + default_fields
        else
          fields || default_fields
        end
      else
        default_fields
      end
    end
end