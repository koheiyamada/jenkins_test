HqUser.all.each do |hq_user|
  if hq_user.access_authority.blank?
    hq_user.access_authority = AccessAuthority.new
    hq_user.save
  end
end
