class ValidationError < StandardError
  def initialize(model)
    @model = model
  end

  attr_reader :model

  def errors
    @model.errors
  end

  def messages
    @model.errors.full_messages
  end
end