class CreateTarFacturas < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_facturas do |t|
      t.string :owner_class
      t.integer :owner_id
      t.integer :documento
      t.string :estado

      t.timestamps
    end
    add_index :tar_facturas, :owner_class
    add_index :tar_facturas, :owner_id
    add_index :tar_facturas, :estado
  end
end
