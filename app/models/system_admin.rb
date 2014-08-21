class SystemAdmin < User
  def root_path
    admin_root_path
  end

  def admin?
    true
  end
end
