class CreateControlDocumentos < ActiveRecord::Migration[5.2]
  def change
    create_table :control_documentos do |t|
      t.string :nombre
      t.string :descripcion
      t.string :tipo
      t.string :control
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :control_documentos, :owner_class
    add_index :control_documentos, :owner_id
  end
end
