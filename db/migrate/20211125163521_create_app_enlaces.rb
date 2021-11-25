class CreateAppEnlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :app_enlaces do |t|
      t.string :descripcion
      t.string :enlace
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :app_enlaces, :owner_class
    add_index :app_enlaces, :owner_id
  end
end
