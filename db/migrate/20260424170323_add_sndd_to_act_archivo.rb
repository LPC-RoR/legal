class AddSnddToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :sndd, :boolean
    add_index :act_archivos, :sndd
  end
end
