class CreateTarTarifas < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_tarifas do |t|
      t.string :tarifa
      t.string :estado
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :tar_tarifas, :estado
    add_index :tar_tarifas, :owner_class
    add_index :tar_tarifas, :owner_id
  end
end
