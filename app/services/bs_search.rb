class BsSearch

  def initialize(user)
    @user = user
  end

  attr_reader :user

  def search(key, options)
    search = Bs.search do
      if options[:page].present?
        paginate :page => options[:page], :per_page => 25
      end
      unless options[:active].nil?
        with :active, options[:active]
      end
      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end
end