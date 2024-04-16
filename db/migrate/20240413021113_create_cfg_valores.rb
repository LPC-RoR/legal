class CreateCfgValores < ActiveRecord::Migration[5.2]
  def change
    create_table :cfg_valores do |t|
      t.string :cfg_valor
      t.string :tipo
      t.decimal :numero
      t.string :palabra
      t.text :texto
      t.date :fecha
      t.datetime :fecha_hora
      t.boolean :check_box
      t.integer :app_version_id

      t.timestamps
    end
    add_index :cfg_valores, :cfg_valor
    add_index :cfg_valores, :tipo
    add_index :cfg_valores, :app_version_id
  end
end
