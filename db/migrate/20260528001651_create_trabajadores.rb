class CreateTrabajadores < ActiveRecord::Migration[8.0]
  def change
    create_table :trabajadores do |t|
      t.string :nombre
      t.string :rut

      t.timestamps
    end
    add_index :trabajadores, :rut
  end
end
