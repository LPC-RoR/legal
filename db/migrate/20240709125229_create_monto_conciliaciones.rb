class CreateMontoConciliaciones < ActiveRecord::Migration[7.1]
  def change
    create_table :monto_conciliaciones do |t|
      t.integer :causa_id
      t.string :tipo
      t.datetime :fecha
      t.decimal :monto
      t.string :nota

      t.timestamps
    end
    add_index :monto_conciliaciones, :causa_id
  end
end
