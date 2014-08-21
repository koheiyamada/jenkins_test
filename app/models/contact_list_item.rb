class ContactListItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :contactable, :polymorphic => true
end
