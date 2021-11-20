class CreateTarValores < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_valores do |t|
      t.string :codigo
      t.string :detalle
      t.decimal :valor_uf
      t.decimal :valor
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :tar_valores, :codigo
    add_index :tar_valores, :owner_class
    add_index :tar_valores, :owner_id
  end
end
