class CreateTarValorCuantias < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_valor_cuantias do |t|
      t.string :owner_class
      t.integer :owner_id
      t.integer :tar_detalle_cuantia_id
      t.string :otro_detalle
      t.decimal :valor
      t.decimal :valor_uf

      t.timestamps
    end
    add_index :tar_valor_cuantias, :owner_class
    add_index :tar_valor_cuantias, :owner_id
    add_index :tar_valor_cuantias, :tar_detalle_cuantia_id
  end
end
