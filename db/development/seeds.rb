if Rails.env.development?
  HqUser.create!(user_name:"hq_accountant", email:"hq_accountant@soba-project.com", password:"password")
  HqUser.create!(user_name:"hq_support", email:"hq_support@soba-project.com", password:"password")
  HqUser.create!(user_name:"hq_user", email:"hq_user@soba-project.com", password:"password")

  address = Address.new(postal_code:"604-0873", state:"京都府", line1:"京都市中京区少将井御旅町")

  bs = Bs.create(name: "Test BS", email:"shimokawa@soba-project.com", phone_number:"111-1111-1111", address:address)
  bs.create_member(
    user_name:"bs_user",
    email:"bs_user@soba-project.com",
    password:"password",
    first_name: "太郎",
    last_name: "BS"
  )

  subject = Subject.create(name: "英語")

  Tutor.create!(user_name:"tutor", email:"tutor@soba-project.com", password:"password") do |user|
    user.first_name = '太郎'
    user.last_name = 'tutor'
    user.organization = Headquarter.instance # チューターは本部に所属
    user.info = TutorInfo.create! do |info|
      info.phone_mail = "shimokawa@soba-project.com"
      info.pc_mail = "shimokawa@soba-project.com"
      info.confirmed = false
      info.status = "new"
      info.college = "京都大学"
      info.department = "工学部"
      info.year_of_admission = 1995
      info.year_of_graduation = 1999
      info.activities = "野球、テレビゲーム、プログラミング"
      info.high_school = "福岡高校"
      info.birth_place = "福岡"
    end
    user.subjects = [subject]
  end

  parent = Parent.create!(user_name: "parent", email:"parent@soba-project.com", password:"password", nickname:"Pare") do |user|
    user.organization = bs
    user.first_name = '太郎'
    user.last_name = '保護者'
  end

  student = Student.create!(user_name: "student", email:"student@soba-project.com", password:"password", nickname:"Taro")
  student.organization = bs
  student.parent = parent
  student.first_name = '太郎'
  student.last_name = '生徒'
  student.save!
end
