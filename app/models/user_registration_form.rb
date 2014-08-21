class UserRegistrationForm < ActiveRecord::Base
  belongs_to :user
  belongs_to :os, class_name:OperatingSystem.name

  attr_accessible :adsl, :email

  validates_presence_of :email
  validates_format_of :email, :with => User.mail_address_pattern, :message => :unacceptable_format, :unless => :development_or_test?

  before_create :publish_confirmation_token

  # 低スペック => エントリーできない
  # 高スペック =>
  #  回線速度十分 => OK
  #  回線速度そこそこ => OK（ただしノートカメラ無理）
  #  回線速度遅すぎる => エントリーできない
  #  回線速度不明 => OK（回線速度の注意書き）
  # スペック不明 =>
  #  回線速度十分 => OK（スペックの注意書き）
  #  回線速度そこそこ => OK（スペックの注意書き、ノートカメラ無理）
  #  回線速度遅すぎる => エントリーできない
  #  回線速度不明 => OK（スペックの注意書き、回線速度の注意書き）
  def check
    if invalid?
      :invalid
    elsif pc_spec_given?
      if pc_spec_good_enough?
        if line_speed_too_slow?
          :line_speed_too_slow
        end
      else
        :spec_too_low
      end
    else
      if line_speed_too_slow?
        :line_speed_too_slow
      end
    end
  end

  def line_speed_given?
    upload_speed.present? && download_speed.present?
  end

  def line_speed_fast_enough?
    line_speed_given? && upload_speed >= 3 && download_speed >= 3
  end

  def line_speed_too_slow?
    line_speed_given? && (upload_speed < 0.5 && download_speed < 0.5)
  end

  def pc_spec_given?
    windows_experience_index_score.present?
  end

  def pc_spec_good_enough?
    pc_spec_given? && windows_experience_index_score >= 3
  end

  def pc_spec_low?
    pc_spec_given? && windows_experience_index_score < 3
  end

  private

    def publish_confirmation_token
      self.confirmation_token = generate_token
    end

    def generate_token
      charset = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      Array.new(32){ charset.sample }.join
    end
end
