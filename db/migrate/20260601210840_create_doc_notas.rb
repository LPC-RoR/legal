class CreateDocNotas < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_notas do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.string :nota

      t.timestamps
    end
    add_index :doc_notas, :ownr_type
    add_index :doc_notas, :ownr_id
  end
end
