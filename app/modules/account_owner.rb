module AccountOwner
  def has_paid?(account_item_class)
    account_item_class.where(owner_id:self.id).any?
  end

  def pay(account_item_class)
    account_item_class.create!(payer:self)
  end
end