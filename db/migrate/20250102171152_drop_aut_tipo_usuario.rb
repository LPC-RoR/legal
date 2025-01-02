class DropAutTipoUsuario < ActiveRecord::Migration[7.1]
  def change
    drop_table :aut_tipo_usuarios
  end
end
