module WebApi

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def public_api(*methods)
      before_filter :set_access, :only => methods
    end
  end

  private

    def set_access
      response.headers['Access-Control-Allow-Origin'] = '*'
    end
end