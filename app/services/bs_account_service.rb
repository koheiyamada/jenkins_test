# coding: utf-8

class BsAccountService
  include Loggable

  def initialize(bs)
    @bs = bs
  end

  attr_reader :bs

  def reactivate
    unless bs.active?
      activate_bs_and_representative
    end
    true
  rescue => e
    logger.error e
    false
  end

  def deactivate
    bs.leave
  end

  private

  def activate_bs_and_representative
    Bs.transaction do
      bs.activate
      if bs.representative
        bs.representative.revive!
      end
    end
  end

end