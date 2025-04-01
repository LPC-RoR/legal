class AddEvlcnFailToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :evlcn_desaprobada, :boolean
  end
end
