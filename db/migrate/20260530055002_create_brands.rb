class CreateBrands < ActiveRecord::Migration[8.0]
  def change
    create_table :brands do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :brands, "lower(name)", unique: true, name: "index_brands_on_lower_name"
  end
end
