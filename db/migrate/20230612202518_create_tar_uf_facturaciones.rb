class CreateTarUfFacturaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_uf_facturaciones do |t|
      t.string :owner_class
      t.integer :owner_id
      t.string :pago
      t.datetime :fecha_uf

      t.timestamps
    end
    add_index :tar_uf_facturaciones, :owner_class
    add_index :tar_uf_facturaciones, :owner_id
    add_index :tar_uf_facturaciones, :pago
    add_index :tar_uf_facturaciones, :fecha_uf
  end
end
