class ActiveRecord::Base
  def development_or_test?
    Rails.env.development? || Rails.env.test?
  end
end