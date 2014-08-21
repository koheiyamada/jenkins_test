class BsAppFormSearch
  def initialize(user)
    @user = user
  end

  attr_reader :user

  def search(key, options)
    search = BsAppForm.search do
      [:status].each do |filter|
        with filter, options[filter] if options.has_key?(filter)
      end
      if options[:page]
        paginate :page => options[:page], :per_page => 25
      end
      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end

  def search_unprocessed_forms(key, options={})
    options.merge!(status: BsAppForm::Status::NEW)
    search(key, options)
  end

  def search_processed_forms(key, options={})
    options.merge!(status: [BsAppForm::Status::ACCEPTED, BsAppForm::Status::REJECTED])
    search(key, options)
  end
end