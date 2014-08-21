# encoding:utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Headquarter.count == 0
  Headquarter.create!(name:"本部")
end

if HqUser.count == 0
  HqUser.create!(user_name: "admin", email: "shimokawa@soba-project.com", password:"c69AUY") do |user|
    user.organization = Headquarter.first
    user.admin = true
  end
end

if Guest.count == 0
  Guest.create!(user_name:'guest_user', password:'guest_user_password', email:'shimokawa@soba-project.com')
end

if SystemAdmin.count == 0
  SystemAdmin.create!(user_name:'system_admin', password:'5nOtPu', email:'shimokawa@soba-project.com')
end

#
require File.dirname(__FILE__) + '/seeds/organizations'
require File.dirname(__FILE__) + '/seeds/system_settings'
require File.dirname(__FILE__) + '/seeds/grades'
require File.dirname(__FILE__) + '/seeds/grade_groups'
require File.dirname(__FILE__) + '/seeds/subjects'

require File.dirname(__FILE__) + '/seeds/charge_settings'
require File.dirname(__FILE__) + '/seeds/rate_settings'
require File.dirname(__FILE__) + '/seeds/textbooks'
require File.dirname(__FILE__) + '/seeds/operating_systems'
require File.dirname(__FILE__) + '/seeds/banks'
require File.dirname(__FILE__) + '/seeds/questions'
