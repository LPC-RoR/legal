class CreateTarBases < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_bases do |t|
      t.string :base
      t.decimal :monto_uf
      t.decimal :monto
      t.string :owner_class
      t.integer :owner_id
      t.integer :perfil_id

      t.timestamps
    end
    add_index :tar_bases, :owner_class
    add_index :tar_bases, :owner_id
    add_index :tar_bases, :perfil_id
  end
end
