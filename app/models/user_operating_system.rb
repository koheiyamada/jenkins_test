class UserOperatingSystem < ActiveRecord::Base
  belongs_to :user
  belongs_to :operating_system
  has_one :custom_operating_system
  attr_writer :custom_os_name
  attr_accessible :custom_os_name, :operating_system_id

  validates_presence_of :operating_system_id
  validates_presence_of :custom_os_name, if: :using_unknown_os?

  after_create :create_custom_os, if: :using_unknown_os?

  def name
    @name ||= resolve_name
  end

  def custom_os_name
    @custom_os_name ||= resolve_custom_os_name
  end

  private

    def resolve_custom_os_name
      custom_operating_system && custom_operating_system.name
    end

    def resolve_name
      if custom_operating_system.present?
        operating_system.name + ':' + custom_operating_system.name
      else
        operating_system.name
      end
    end

    def using_unknown_os?
      operating_system.present? && operating_system.unknown?
    end

    def create_custom_os
      create_custom_operating_system(name: custom_os_name)
    end
end
