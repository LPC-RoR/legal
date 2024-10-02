class DropReceptoresDenuncia < ActiveRecord::Migration[7.1]
  def change
    drop_table :receptor_denuncias
    drop_table :denuncias
  end
end
