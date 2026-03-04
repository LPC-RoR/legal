class CreateActReferencias < ActiveRecord::Migration[8.0]
  def change
    create_table :act_referencias do |t|
      t.integer :act_archivo_id
      t.string :ref_type
      t.integer :ref_id

      t.timestamps
    end
    add_index :act_referencias, :act_archivo_id
    add_index :act_referencias, :ref_type
    add_index :act_referencias, :ref_id
  end
end
