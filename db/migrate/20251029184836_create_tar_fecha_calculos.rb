class CreateTarFechaCalculos < ActiveRecord::Migration[8.0]
  def change
    create_table :tar_fecha_calculos do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.date :fecha
      t.string :codigo_formula

      t.timestamps
    end
    add_index :tar_fecha_calculos, :ownr_type
    add_index :tar_fecha_calculos, :ownr_id
    add_index :tar_fecha_calculos, :codigo_formula
  end
end
