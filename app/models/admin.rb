class Admin < User
  # attr_accessible :title, :body

  def root_path
    admin_root_path
  end
end
