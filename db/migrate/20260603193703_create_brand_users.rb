class CreateBrandUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :brand_users do |t|
      t.references :brand, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :brand_users, [ :brand_id, :user_id ], unique: true
  end
end
