# coding: utf-8

class ParentStudentUpdateForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include Loggable
  include UserFormMethods

  attr_reader :user

  def initialize(student)
    @student = student
  end

  def user
    @student
  end

  def persisted?
    false
  end

  def save
    if valid?
      save_all
    else
      logger.debug errors.full_messages
      false
    end
  end

  def update(params)
    @student.attributes = params[:student]
    if @student.address
      @student.address.attributes = (params[:address])
    else
      @student.build_address(params[:address])
    end
    @student.student_info.attributes = params[:student_info]
    if params[:user_operating_system].present?
      @student.build_user_operating_system(params[:user_operating_system])
    end
    save
  end

  private

    def save_all
      Student.transaction do
        @student.save!
        true
      end
    rescue => e
      logger.error e
      false
    end
end