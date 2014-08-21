class BasicLessonForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :tutor_id, :subject_id, :year_month, :wday, :start_time, :units
  attr_accessor :year, :month, :hour, :minute, :group_lesson

  def initialize(params = {})
    self.tutor_id = params[:tutor_id]
    self.subject_id = params[:subject_id]
    if params[:year_month]
      d = Date.parse(params[:year_month])
      self.year_month = d
      self.year = d.year
      self.month = d.month
    end
    self.hour = params[:hour].to_i if params[:hour]
    self.minute = params[:minute].to_i if params[:minute]
    self.wday = params[:wday].to_i if params[:wday]
    self.units = params[:units].to_i if params[:units]
    self.group_lesson = params[:group_lesson].present?
  end

  def persisted?
    false
  end
end