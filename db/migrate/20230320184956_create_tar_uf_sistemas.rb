class CreateTarUfSistemas < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_uf_sistemas do |t|
      t.date :fecha
      t.decimal :valor

      t.timestamps
    end
    add_index :tar_uf_sistemas, :fecha
  end
end
