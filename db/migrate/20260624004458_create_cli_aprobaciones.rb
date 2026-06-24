class CreateCliAprobaciones < ActiveRecord::Migration[8.0]
  def change
    create_table :cli_aprobaciones do |t|
      t.date :fecha, null: false
      t.references :cliente, null: false, foreign_key: true
      t.timestamps
    end

    # Índice único compuesto: un cliente solo puede tener una aprobación por fecha
    add_index :cli_aprobaciones, [:cliente_id, :fecha], unique: true
  end
end
