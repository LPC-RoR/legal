class DropAppDocumentos < ActiveRecord::Migration[8.0]
  def change
    drop_table :app_documentos
  end
end
