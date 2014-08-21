module LessonRequestHelper
  def create_optional_lesson(params)
    tutor = params[:tutor]
    t = params[:time]
    student = params[:student]
    subject = params[:subject]
    optional_lesson = {
      tutor_id:tutor.id, subject_id:subject.id, start_time:t
    }
    lesson = OptionalLesson.new(optional_lesson)
    lesson.students << student
    lesson.save!
    lesson
  end
end

RSpec.configure do |config|
  config.include LessonRequestHelper, :type => :request
end
