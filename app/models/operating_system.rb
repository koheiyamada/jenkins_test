# coding: utf-8

class OperatingSystem < ActiveRecord::Base
  class << self
    def list
      where(active: true).order(:display_order)
    end

    def default
      windows8
    end

    def windows8
      @windows8 ||= find_by_name('Windows 8')
    end
  end
  attr_accessible :name, :windows_experience_index_score_available, :display_order, :active

  validates_presence_of :name, :display_order
  validates_uniqueness_of :name
  validates_numericality_of :display_order, only_integer: true

  def unknown?
    name == 'その他'
  end
end
