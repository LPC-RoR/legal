class CreateCausaDocs < ActiveRecord::Migration[5.2]
  def change
    create_table :causa_docs do |t|
      t.integer :causa_id
      t.integer :app_documento_id

      t.timestamps
    end
    add_index :causa_docs, :causa_id
    add_index :causa_docs, :app_documento_id
  end
end
