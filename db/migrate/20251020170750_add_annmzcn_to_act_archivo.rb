class AddAnnmzcnToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :anonimizado, :boolean, default: false, null: false
    add_column :act_archivos, :anonimizado_de_id, :bigint
    add_foreign_key :act_archivos, :act_archivos, column: :anonimizado_de_id
    add_index  :act_archivos, :anonimizado_de_id
  end
end