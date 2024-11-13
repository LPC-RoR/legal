class CreateProDtllVentas < ActiveRecord::Migration[7.1]
  def change
    create_table :pro_dtll_ventas do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.integer :producto_id
      t.datetime :fecha_activacion

      t.timestamps
    end
    add_index :pro_dtll_ventas, :ownr_type
    add_index :pro_dtll_ventas, :ownr_id
    add_index :pro_dtll_ventas, :producto_id
  end
end
