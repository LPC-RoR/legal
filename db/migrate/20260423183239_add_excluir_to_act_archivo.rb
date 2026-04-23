class AddExcluirToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :excluir, :boolean
    add_index :act_archivos, :excluir
    add_column :check_realizados, :excluir, :boolean
    add_index :check_realizados, :excluir
  end
end
