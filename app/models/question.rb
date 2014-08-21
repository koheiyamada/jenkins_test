class Question < ActiveRecord::Base
  has_many :answer_options
  attr_accessible :code, :title

  def form_class
    codes = answer_options.map{|option| option.code.to_sym}
    @form_class ||= Struct.new(*codes)
  end

  def answer_form
    form_class.new
  end

  def build_answer(responder, params)
    logger.debug params
    code = params[:answer_option_code]
    answer_option = answer_options.where(code: code).first
    logger.debug answer_option
    Answer.new(owner: responder, answer_option: answer_option).init
  end

  def create_answer(responder, code)
    answer_option = answer_options.where(code: code).first
    responder.answers.create(answer_option: answer_option)
  end
end
