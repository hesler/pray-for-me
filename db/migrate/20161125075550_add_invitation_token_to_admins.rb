class AddInvitationTokenToAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :invitation_token, :string
  end
end
