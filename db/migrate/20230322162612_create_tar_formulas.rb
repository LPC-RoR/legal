class CreateTarFormulas < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_formulas do |t|
      t.integer :orden
      t.integer :tar_pago_id
      t.string :tar_formula
      t.string :mensaje
      t.string :error

      t.timestamps
    end
    add_index :tar_formulas, :tar_pago_id
    add_index :tar_formulas, :tar_formula
  end
end
