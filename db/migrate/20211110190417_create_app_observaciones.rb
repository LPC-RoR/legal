class CreateAppObservaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :app_observaciones do |t|
      t.text :detalle
      t.string :owner_class
      t.integer :owner_id
      t.integer :perfil_id

      t.timestamps
    end
    add_index :app_observaciones, :owner_class
    add_index :app_observaciones, :owner_id
    add_index :app_observaciones, :perfil_id
  end
end
