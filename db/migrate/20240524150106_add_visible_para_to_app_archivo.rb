class AddVisibleParaToAppArchivo < ActiveRecord::Migration[5.2]
  def change
    add_column :app_archivos, :visible_para, :string
    add_index :app_archivos, :visible_para
  end
end
