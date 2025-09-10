class CreateActArchivos < ActiveRecord::Migration[8.0]
  def change
    create_table :act_archivos do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.string :act_archivo
      t.string :nombre

      t.timestamps
    end
    add_index :act_archivos, :ownr_type
    add_index :act_archivos, :ownr_id
    add_index :act_archivos, :act_archivo
  end
end
