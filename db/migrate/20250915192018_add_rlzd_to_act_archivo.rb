class AddRlzdToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :rlzd, :boolean
    add_index :act_archivos, :rlzd
  end
end
