class AddSeleccionadoToCausaDoc < ActiveRecord::Migration[5.2]
  def change
    add_column :causa_docs, :seleccionado, :boolean
    add_index :causa_docs, :seleccionado
  end
end
