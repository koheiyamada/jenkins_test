# encoding:utf-8

# 小学3年から高校3年＋その他で11学年
config = YAML.load_file Rails.root.join('db/data/grades.yml')

ActiveRecord::Base.transaction do
  config.each do |attr|
    id = attr.delete('id')
    grade = Grade.find_by_id id
    if grade
      grade.update_attributes! attr
    else
      Grade.create! attr
    end
  end
end
