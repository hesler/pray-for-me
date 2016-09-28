class CreateIntentions < ActiveRecord::Migration
  def change
    create_table :intentions do |t|
      t.text :content
      t.string :country
      t.string :city
      t.string :region
      t.decimal :lat
      t.decimal :lng
      t.boolean :published, default: false
      t.timestamps
    end
  end
end
