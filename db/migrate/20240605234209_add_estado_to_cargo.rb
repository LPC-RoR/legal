class AddEstadoToCargo < ActiveRecord::Migration[5.2]
  def change
    add_column :cargos, :estado, :string
    add_index :cargos, :estado
  end
end
