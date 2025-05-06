class AddGrupoToAppContacto < ActiveRecord::Migration[8.0]
  def change
    add_column :app_contactos, :grupo, :string
    add_index :app_contactos, :grupo
  end
end
