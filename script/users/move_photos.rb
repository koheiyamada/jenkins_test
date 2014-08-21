# coding:utf-8

#
# モデルごとに別々のディレクトリにアップロードされていた写真を
# 共通のディレクトリ以下に移動する。
# 例えばuploads/tutors/photo/:id/xxx.jpgをuploads/users/photo/:id/xxx.jpgに移動する。
#

root_dir = Rails.root.join 'public/uploads'
models   = %w(Tutor SpecialTutor Student Parent BsUser)
user_dir = root_dir + 'user'

unless File.exist? user_dir
  puts "creating #{user_dir}"
  FileUtils.makedirs user_dir
end

models.each do |model|
  dir = root_dir + model.underscore
  if File.exist? dir
    from = dir + 'photo'
    to   = user_dir
    puts "moving from #{from} to #{to}..."
    FileUtils.cp_r from, to
  end
end
