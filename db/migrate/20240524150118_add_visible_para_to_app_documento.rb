class AddVisibleParaToAppDocumento < ActiveRecord::Migration[5.2]
  def change
    add_column :app_documentos, :visible_para, :string
    add_index :app_documentos, :visible_para
  end
end
