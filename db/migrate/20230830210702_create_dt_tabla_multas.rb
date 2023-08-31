class CreateDtTablaMultas < ActiveRecord::Migration[5.2]
  def change
    create_table :dt_tabla_multas do |t|
      t.string :dt_tabla_multa

      t.timestamps
    end
    add_index :dt_tabla_multas, :dt_tabla_multa
  end
end
