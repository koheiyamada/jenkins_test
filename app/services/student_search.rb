# coding:utf-8

class StudentSearch
  include Loggable

  def initialize(user)
    @user = user
  end

  attr_reader :user

  def search(key, options)
    search = Student.search do
      [:active, :locked, :left, :trial].each do |filter|
        with filter, options[filter] if options.has_key?(filter)
      end
      if limit_by_organization?
        with :organization_id, user.organization_id
      end
      if options[:page]
        paginate :page => options[:page], :per_page => 25
      end
      if options[:without].present?
        without :student_id, options[:without]
      end
      if options[:student_id].present?
        logger.debug "Search target is restricted to #{options[:student_id]}"
        with :student_id, options[:student_id]
      end
      if options[:exclude_trial]
        without :trial, true
      end
      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end

  def search_left_students(key, options={})
    options.merge!(left: true)
    search(key, options)
  end

  def search_trial_students(key, options={})
    options.merge!(trial: true)
    search(key, options)
  end

  private

    # 検索をuserの所属グループ内で区切る場合はtrueを返す
    def limit_by_organization?
      !(user.hq_user? || user.student?)
    end
end