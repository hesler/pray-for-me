class AddConfirmedAtToAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :confirmed_at, :datetime
  end
end
