# coding: utf-8

config = YAML.load_file(Rails.root.join('db/data/questions.yml'))

config.each do |q_attrs|
  q = Question.where(code: q_attrs[:code]).first_or_create!(title: q_attrs[:title])
  q_attrs[:answer_options].each do |a_option_attrs|
    q.answer_options.where(code: a_option_attrs[:code]).first_or_create!
  end
end