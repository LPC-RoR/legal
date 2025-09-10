class AddMdlToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :mdl, :string
    add_index :act_archivos, :mdl
  end
end
