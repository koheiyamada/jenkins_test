module HqUserAccessControl

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def access_control(resource=nil)
      if resource.nil?
        resource = name.underscore.split('/').last.gsub('_controller', '').singularize
      end
      @access_controlled_resource = resource
      before_filter :only_readable_user
      before_filter :only_writable_user, :only => [:new, :create, :edit, :udpate]
      before_filter :only_writable_user_unless_get
    end

    def access_controlled_resource
      @access_controlled_resource
    end
  end


  private

    def only_readable_user
      unless current_user.can_access?(self.class.access_controlled_resource, :read)
        render template: 'errors/error_403', status: 403
      end
    end

    def only_writable_user
      unless current_user.can_access?(self.class.access_controlled_resource, :write)
        render template: 'errors/error_403', status: 403
      end
    end

    def only_writable_user_unless_get
      unless request.get?
        unless current_user.can_access?(self.class.access_controlled_resource, :write)
          render template: 'errors/error_403', status: 403
        end
      end
    end
end