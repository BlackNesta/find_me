class AddUsersCountToBrands < ActiveRecord::Migration[8.0]
  def change
    add_column :brands, :users_count, :integer, null: false, default: 0
  end
end
