# coding: utf-8

class Grade < ActiveRecord::Base

  class << self
    def default
      last
    end

    def order_by_grade
      order('grade_order')
    end
  end

  scope :normal, where(special: false)

  attr_accessible :code, :next_grade_id, :premium, :special, :grade_order

  belongs_to :next_grade, class_name:Grade.name
  belongs_to :group, class_name:GradeGroup.name

  def name
    I18n.t("grades.#{code}.name")
  end

  # この学年向けの全教科を返す
  def subjects
    if group.present?
      group.subjects
    else
      Subject.scoped
    end
  end

  def in_elementary_school?
    code.start_with?('es')
  end

  def display_name
    I18n.t("grades.#{code}.name")
  end

  def all_grades_for_select_box
    {
      "学年"=>nil,
      "小学1年"=>"es1",
      "小学2年"=>"es2",
      "小学3年"=>"es3",
      "小学4年"=>"es4",
      "小学5年"=>"es5",
      "小学6年"=>"es6",
      "中学1年"=>"jh1",
      "中学2年"=>"jh2",
      "中学3年"=>"jh3",
      "高校1年"=>"hs1",
      "高校2年"=>"hs2",
      "高校3年"=>"hs3",
      "大学受験者"=>"prep",
      "社会人"=>"other",
      "小学5年（中学受験）"=>"es5e",
      "小学6年（中学受験）"=>"es6e"
      #以下項目はカラムに存在しない
      #"社会人（大学受験）"=>"other_e",
    }
  end

  def get_id_from_code code
    Grade.find(:first,:select=>"id",:conditions => {'code'=>code})
  end
end
