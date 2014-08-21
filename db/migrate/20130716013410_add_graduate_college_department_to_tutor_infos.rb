class AddGraduateCollegeDepartmentToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :graduate_college_department, :string

    TutorAppForm.all.each do |form|
      if form.tutor.present?
        tutor = form.tutor
        tutor.info.update_column :graduate_college_department, form.graduate_college_department
        puts "Tutor #{tutor.id}'s graduate_college_department is set '#{form.graduate_college_department}'"
      end
    end
  end
end
