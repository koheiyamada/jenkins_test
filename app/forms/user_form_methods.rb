# coding:utf-8

#
# このモジュールをインクルードするクラスはuserメソッドを実装すること。
#
module UserFormMethods

  def self.included(base)
    base.validate :ensure_user_is_valid
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
    parse_user(params)
    parse_answers(params)
    save
  end

  private

    def save_all
      User.transaction do
        user.save!
        save_answers
        true
      end
    rescue => e
      logger.error e
      false
    end

    def parse_answers(params)
      # do nothing
    end

    def ensure_user_is_valid
      if user.invalid?
        user.errors.full_messages.each do |msg|
          errors.add :user, msg
        end
      end
    end

    def parse_user_operating_system(params)
      if params[:user_operating_system].present?
        user.build_user_operating_system(params[:user_operating_system])
      end
    end

    def parse_address(params)
      if user.address
        user.address.attributes = params[:address]
      else
        user.build_address(params[:address])
      end
    end

    def parse_address2(params, field_name)
      address = user.send field_name
      if address
        address.attributes = params[field_name]
      else
        user.send "build_#{field_name}", params[field_name]
      end
    end
end