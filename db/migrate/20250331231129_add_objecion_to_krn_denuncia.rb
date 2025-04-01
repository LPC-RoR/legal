class AddObjecionToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :objcn_acogida, :boolean
    add_column :krn_denuncias, :objcn_rechazada, :boolean
  end
end
