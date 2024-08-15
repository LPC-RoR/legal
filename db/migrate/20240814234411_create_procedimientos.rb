class CreateProcedimientos < ActiveRecord::Migration[7.1]
  def change
    create_table :procedimientos do |t|
      t.string :procedimiento
      t.integer :tipo_procedimiento_id
      t.text :detalle

      t.timestamps
    end
    add_index :procedimientos, :tipo_procedimiento_id
  end
end
