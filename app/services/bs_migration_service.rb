class BsMigrationService
  def initialize(bs)
    @bs = bs
  end

  def immigrate_students_from_headquarter
    Headquarter.instance.students.each do |student|
      if @bs.area_code && student.area_code == @bs.area_code
        student.change_bs(@bs)
      end
    end
  end
end