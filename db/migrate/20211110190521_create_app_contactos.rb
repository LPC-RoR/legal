class CreateAppContactos < ActiveRecord::Migration[5.2]
  def change
    create_table :app_contactos do |t|
      t.string :nombre
      t.string :telefono
      t.string :email
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :app_contactos, :owner_class
    add_index :app_contactos, :owner_id
  end
end
