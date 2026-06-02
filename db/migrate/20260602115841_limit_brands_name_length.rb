class LimitBrandsNameLength < ActiveRecord::Migration[8.0]
  def up
    change_column :brands, :name, :string, limit: 255, null: false
  end

  def down
    change_column :brands, :name, :string, limit: nil, null: false
  end
end
