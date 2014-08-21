class BasicLessonSearch
  def initialize(params)
    configure(params)
  end

  attr_reader :key, :options, :student_ids_to_exclude

  def execute
    config = self
    search = BasicLessonInfo.search do
      config.options.each do |k, v|
        with(k, v)
      end
      if config.student_ids_to_exclude
        without(:student_ids, config.student_ids_to_exclude)
      end
      fulltext SearchUtils.normalize_key(config.key)
    end
    search.results
  end

  private

  def configure(params)
    @key = params[:q]
    @options = {active: true}

    if params[:wday].present?
      @options[:wdays] = params[:wday].to_i
    end

    if params[:start_time][:hour].present?
      options[:start_time_hours] = params[:start_time][:hour].to_i
    end

    if params[:only_not_full].present?
      @options[:full] = params[:only_not_full] != '1'
    end

    if params[:shared_lesson].present?
      @options[:shared_lesson] = params[:shared_lesson]
    end

    if params[:active].present?
      @options[:active] = params[:active]
    end

    if params[:student_ids_to_exclude]
      @student_ids_to_exclude = params[:student_ids_to_exclude]
    end
  end
end