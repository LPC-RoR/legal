class AddEstadosToStModelo < ActiveRecord::Migration[5.2]
  def change
    add_column :st_modelos, :k_estados, :string
  end
end
