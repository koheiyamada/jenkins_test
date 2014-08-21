class StudentForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_reader :questions
  attr_reader :params

  def initialize(params = {})
    @params = params
    @questions = {}
    @student_registration_form = params[:student_registration_form]
    @address = Address.new(params[:address])
    @student = Student.new(params[:student]) do |student|
      student.password = Student.generate_password
      student.address = @address
      if @student_registration_form.present?
        student.email = @student_registration_form.email
        student.registration_form = @student_registration_form
        student.spec = @student_registration_form
      end
      student.student_info = StudentInfo.new(params[:student_info])
      student.payment_method = PaymentMethod.new(params[:payment_method])
    end
  end

  attr_reader :student

  def persisted?
    false
  end

  def save
    if @student.save
      process_questions
    else
      @student.errors.full_messages.each do |msg|
        errors.add :student, msg
      end
    end
    self.errors.empty?
  end

  def error_messages

  end

  def process_questions
    if params[:question]
      q_params = params[:question]

      q1_params = q_params[:how_to_find]
      if q1_params
        process_how_to_find_question(q1_params)
        if questions[:how_to_find]
          questions[:how_to_find][:answers].present?
        else
        end
      end

      q2_params = q_params[:reason_to_enroll]
      if q1_params
        process_reason_to_enroll_question(q2_params)
      end
    end
  end

  def process_how_to_find_question(params)
    q = Question.find_by_code('how_to_find')
    qa = QuestionAnswering.new(student)
    answer_option_code = params[:answer_option]
    answer_option = q.answer_options.find_by_code(answer_option_code)
    if answer_option.present?
      value_key = answer_option_code + '_value'
      answer_value = params[value_key]
      answer = qa.answer(answer_option, answer_value)
      questions[:how_to_find] = {answers: [answer]}
    end
  end

  def process_reason_to_enroll_question(params)
    question = {:answers => []}

    q = Question.find_by_code('reason_to_enroll')
    qa = QuestionAnswering.new(student)

    answer_flags = params[:answer_option]
    answer_flags.each do |answer_option_code, flag|
      if flag == '1'
        answer_option = q.answer_options.find_by_code(answer_option_code)
        value_key = answer_option_code + '_value'
        answer_value = params[value_key]
        answer = qa.answer(answer_option, answer_value)
        question[:answers] << answer
      end
    end
    questions[:reason_to_enroll] = {answers: []}
  end
end