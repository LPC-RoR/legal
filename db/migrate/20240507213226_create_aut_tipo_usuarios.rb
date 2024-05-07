class CreateAutTipoUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :aut_tipo_usuarios do |t|
      t.string :aut_tipo_usuario

      t.timestamps
    end
    add_index :aut_tipo_usuarios, :aut_tipo_usuario
  end
end
