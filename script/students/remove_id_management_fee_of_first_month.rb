Student.only_active.find_each do |student|
  s = StudentMembershipService.new(student)
  month = s.enrolled_month
  id_management_fee = student.id_management_fees.of_month(month.year, month.month).first
  if id_management_fee.present?
    puts "Student #{student.id} has ID Management Fee for the enrollement month! #{month.year}/#{month.month}"
    id_management_fee.destroy
    puts '  ...removed.'
  end
end