class AddOrdenToStPerfilEstado < ActiveRecord::Migration[5.2]
  def change
    add_column :st_perfil_estados, :orden, :integer
    add_index :st_perfil_estados, :orden
  end
end
