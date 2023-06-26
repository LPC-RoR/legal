class CreateAppEscaneos < ActiveRecord::Migration[5.2]
  def change
    create_table :app_escaneos do |t|
      t.string :ownr_class
      t.integer :ownr_id

      t.timestamps
    end
    add_index :app_escaneos, :ownr_class
    add_index :app_escaneos, :ownr_id
  end
end
