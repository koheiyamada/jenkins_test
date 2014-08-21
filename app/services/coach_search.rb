class CoachSearch
  def initialize(user)
    @user = user
  end

  attr_reader :user

  def search(key, options)
    search = Coach.search do
      [:active, :left].each do |filter|
        with filter, options[filter] if options.has_key?(filter)
      end
      if limit_by_organization?
        with :organization_id, user.organization_id
      end
      if options[:page]
        paginate :page => options[:page], :per_page => 25
      end
      if options[:without].present?
        without :coach_id, options[:without]
      end
      if options[:coach_id].present?
        with :coach_id, options[:coach_id]
      end
      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end

  def search_active_coaches(key, options)
    options.merge!(active: true)
    search(key, options)
  end

  def search_left_coaches(key, options)
    options.merge!(active: false)
    search(key, options)
  end

  private

    # 検索をuserの所属グループ内で区切る場合はtrueを返す
    def limit_by_organization?
      !(user.hq_user?)
    end
end