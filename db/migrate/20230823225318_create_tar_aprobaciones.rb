class CreateTarAprobaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_aprobaciones do |t|
      t.integer :cliente_id
      t.datetime :fecha

      t.timestamps
    end
    add_index :tar_aprobaciones, :cliente_id
    add_index :tar_aprobaciones, :fecha
  end
end
