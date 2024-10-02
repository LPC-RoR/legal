class RemoveMotivoDenuncia < ActiveRecord::Migration[7.1]
  def change
    drop_table :motivo_denuncias
  end
end
