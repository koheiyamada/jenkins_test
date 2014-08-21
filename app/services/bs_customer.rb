# coding:utf-8

class BsCustomer
  include Loggable

  def initialize(user)
    @user = user
  end

  attr_reader :user

  # 所属するBSを決める。
  # 住所が設定されていない場合は本部所属となる。
  # 住所に該当するBSが存在しない場合も本部所属となる。
  def resolve_bs!
    user.organization = resolve_bs_by_address
    user.save!
    user.organization
  end

  def resolve_bs_by_address(address = user.address)
    if address.blank?
      Headquarter.instance
    else
      find_bs_by_address(address) || Headquarter.instance
    end
  end

  def reset_coach
    if user.student?
      reset_coach_of_student
    end
  end

  private

    def reset_coach_of_student
      coach = find_bs_owner
      if coach.present?
        coach.assign_student(user)
      else
        StudentCoach.clear(user)
      end
    end

    def find_bs_owner
      organization = user.organization
      if organization && organization.is_a?(Bs)
        organization.representative
      end
    end

    def find_bs_by_address(address)
      postal_code = address.postal_code || address.make_postal_code
      if postal_code.present?
        Bs.search_by_postal_code(postal_code){ Headquarter.instance }
      end
    end

    def find_bs_by_postal_code(code)
      code = ZipCode.normalize code
      logger.debug "Bs.search_by_postal_code #{code}"
      zip_code = ZipCode.find_by_code(code)
      logger.debug zip_code
      if zip_code
        case zip_code.area_codes.count
        when 0
          Headquarter.instance
        when 1
          Bs.find_by_area_code(zip_code.area_codes.first.code)
        else
          Headquarter.instance
        end
      else
        logger.debug 'Postal code not found: return nil'
        nil
      end
    end
end