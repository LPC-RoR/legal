class CreateTarHoras < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_horas do |t|
      t.string :tar_hora
      t.string :moneda
      t.decimal :valor
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :tar_horas, :tar_hora
    add_index :tar_horas, :owner_class
    add_index :tar_horas, :owner_id
  end
end
