class SpecialTutor < Tutor
  has_many :special_tutor_fees, class_name: Account::SpecialTutorFee.name, as: :owner

  def special?
    true
  end

  def regular?
    true
  end

  def beginner?
    false
  end

  def update_monthly_journal_entries!(year, month)
    charge_service = SpecialTutorChargeService.new(self)
    if charge_service.charge_for_month(year, month)
    else
    end
  end

  def become_beginner
    become_normal_tutor
    transaction do
      info.become_beginner
      update_column(:type, Tutor.name)
      tutor = Tutor.find(id)
      tutor.price.reset!
      true
    end
  rescue => e
    logger.error e
    false
  end

  def become_regular
    become_normal_tutor
  end

  def can_become_regular_tutor?
    condition_to_be_regular_satisfied?
  end

  def can_become_beginner_tutor?
    !beginner? && !condition_to_be_regular_satisfied?
  end

  def can_become_special_tutor?
    !special?
  end

end
