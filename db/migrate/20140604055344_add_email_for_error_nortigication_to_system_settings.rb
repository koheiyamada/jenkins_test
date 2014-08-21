class AddEmailForErrorNortigicationToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :email_for_error_nortification, :string
  end
end
