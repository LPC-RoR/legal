class AddVisibleParaToControlDocumento < ActiveRecord::Migration[5.2]
  def change
    add_column :control_documentos, :visible_para, :string
    add_index :control_documentos, :visible_para
  end
end
