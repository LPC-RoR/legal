class CreateAppArchivos < ActiveRecord::Migration[5.2]
  def change
    create_table :app_archivos do |t|
      t.string :archivo
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :app_archivos, :owner_class
    add_index :app_archivos, :owner_id
  end
end
