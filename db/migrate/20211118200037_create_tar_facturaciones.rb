class CreateTarFacturaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_facturaciones do |t|
      t.string :facturable
      t.decimal :monto
      t.string :estado
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :tar_facturaciones, :facturable
    add_index :tar_facturaciones, :estado
    add_index :tar_facturaciones, :owner_class
    add_index :tar_facturaciones, :owner_id
  end
end
