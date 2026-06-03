class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.references :settable, polymorphic: true, null: false
      t.string :key, limit: 255
      t.string :value

      t.timestamps
    end

    # One key per owner.
    add_index :settings, [:settable_type, :settable_id, :key], unique: true,
              name: "index_settings_on_settable_and_key"
  end
end
