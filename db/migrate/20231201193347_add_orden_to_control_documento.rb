class AddOrdenToControlDocumento < ActiveRecord::Migration[5.2]
  def change
    add_column :control_documentos, :orden, :integer
    add_index :control_documentos, :orden
  end
end
