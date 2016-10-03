class AddStatusToIntentions < ActiveRecord::Migration[5.0]
  def change
    remove_column :intentions, :published, :boolean, default: false
    add_column :intentions, :status, :integer
  end
end
