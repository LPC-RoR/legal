class CreateDtMultas < ActiveRecord::Migration[5.2]
  def change
    create_table :dt_multas do |t|
      t.integer :orden
      t.string :tamanio
      t.decimal :leve
      t.decimal :grave
      t.decimal :gravisima

      t.timestamps
    end
    add_index :dt_multas, :orden
  end
end
