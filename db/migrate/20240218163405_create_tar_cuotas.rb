class CreateTarCuotas < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_cuotas do |t|
      t.integer :tar_pago_id
      t.integer :orden
      t.string :tar_cuota
      t.string :moneda
      t.decimal :monto
      t.decimal :porcentaje
      t.boolean :ultima_cuota

      t.timestamps
    end
    add_index :tar_cuotas, :tar_pago_id
    add_index :tar_cuotas, :orden
  end
end
