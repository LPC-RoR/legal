class CreateRepArchivos < ActiveRecord::Migration[7.1]
  def change
    create_table :rep_archivos do |t|
      t.references :ownr, polymorphic: true, null: false
      t.string :rep_archivo
      t.string :archivo
      t.integer :rep_doc_controlado_id

      t.timestamps
    end
    add_index :rep_archivos, :rep_archivo
    add_index :rep_archivos, :rep_doc_controlado_id
  end
end
