class CreateHechoDocs < ActiveRecord::Migration[5.2]
  def change
    create_table :hecho_docs do |t|
      t.integer :hecho_id
      t.integer :app_documento_id
      t.string :establece

      t.timestamps
    end
    add_index :hecho_docs, :hecho_id
    add_index :hecho_docs, :app_documento_id
    add_index :hecho_docs, :establece
  end
end
