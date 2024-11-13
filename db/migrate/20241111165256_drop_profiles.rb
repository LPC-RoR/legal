class DropProfiles < ActiveRecord::Migration[7.1]
  def change
    drop_table :pro_nominas
    drop_table :pro_clientes
    drop_table :pro_etapas
  end
end
