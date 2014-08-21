class TutorForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_reader :tutor

  def initialize(params = {})
    tutor_info = TutorInfo.new(params[:tutor_info])
    tutor_price = TutorPrice.new(params[:tutor_price])
    user_operating_system = UserOperatingSystem.new(params[:user_operating_system])
    tutor_class = params[:special_tutor] == '1' ? SpecialTutor : Tutor

    @tutor = tutor_class.new(params[:tutor]) do |tutor|
      tutor.info = tutor_info
      tutor.price = tutor_price
      tutor.current_address = CurrentAddress.new(params[:current_address])
      if params[:hometown_address]
        tutor.hometown_address = HometownAddress.new(params[:hometown_address])
      end
      tutor.user_operating_system = user_operating_system
    end
  end

  def persisted?
    false
  end

  delegate :valid?, :errors, to: :tutor

  def save
    tutor.save
  end
end