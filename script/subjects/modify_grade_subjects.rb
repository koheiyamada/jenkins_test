# coding:utf-8

ActiveRecord::Base.transaction do
  # 「数学」が無ければ作成する
  sugaku = Subject.find_by_name '数学'
  if sugaku.blank?
    puts '教科：数学を作成します'
    sugaku = Subject.create name: '数学'
  end

  # 中学向け科目に算数が含まれていればそれを削除する
  grade_group = GradeGroup.find_by_name '中学生'
  if grade_group.present?
    sansu = Subject.find_by_name '算数'

    if grade_group.subjects.include? sansu
      puts '中学生向け教科から算数を削除します'
      grade_group.subjects.delete sansu
    end

    # 中学向け科目に数学が無ければ追加する
    unless grade_group.subjects.include? sugaku
      puts '中学生向け教科に数学を追加します'
      grade_group.subjects << sugaku
    end

    # 中学校「算数」を指導教科に含んでいるケースがあれば、それらを「数学」に置き換える
    TeachingSubject.where(subject_id: sansu.id, grade_group_id: grade_group.id).each do |ts|
      puts "チューター #{ts.tutor ? ts.tutor.id : '?'} の指導教科 #{ts.grade_group.name}:#{ts.subject.name} を #{sugaku.name} に置き換えます。"
      ts.update_attribute :subject_id, sugaku.id
    end
  end
end
