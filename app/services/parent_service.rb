class ParentService
  include Loggable

  def initialize(parent)
    @parent = parent
  end

  def create_student(params, new_password)
    password = ""
    student = Student.new(params[:student]) do |student|
      if new_password.present?
        password = new_password
      else
        password = Student.generate_password
      end
      student.password = password
      student.address = Address.new(params[:address])
      student.student_info = StudentInfo.new(params[:student_info])
      student.parent = @parent
      if params[:user_operating_system].present?
        student.build_user_operating_system(params[:user_operating_system])
      end
      # 無料・有料判別
      if SystemSettings.free_mode?
        student.free_registration
      else
        student.traditional_registration
      end
    end
    if student.save
      student
    end
  end
end