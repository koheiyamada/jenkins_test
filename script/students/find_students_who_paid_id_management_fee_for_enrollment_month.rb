Student.only_active.find_each do |student|
  s = StudentMembershipService.new(student)
  month = s.enrolled_month
  if student.id_management_fees.of_month(month.year, month.month).present?
    puts "Student #{student.id} has ID Management Fee for the enrollement month! #{month.year}/#{month.month}"
  end
end