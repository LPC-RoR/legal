class CreateCtrRegistros < ActiveRecord::Migration[8.0]
  def change
    create_table :ctr_registros do |t|
      t.integer :tarea_id
      t.integer :ctr_paso_id
      t.string :ownr_type
      t.integer :ownr_id
      t.datetime :fecha
      t.string :glosa
      t.string :valor

      t.timestamps
    end
    add_index :ctr_registros, :tarea_id
    add_index :ctr_registros, :ctr_paso_id
    add_index :ctr_registros, :ownr_type
    add_index :ctr_registros, :ownr_id
  end
end
