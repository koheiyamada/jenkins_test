module FormWithOs
  def self.included(base)
    base.belongs_to :os, class_name: OperatingSystem.name
    base.attr_accessible :custom_os_name
    base.validates_presence_of :custom_os_name, :if => :custom_os?
  end

  private

    def custom_os?
      os.present? && os.unknown?
    end

    def fill_user_operating_system(uos)
      uos.operating_system = os
      uos.custom_os_name = custom_os_name
    end
end