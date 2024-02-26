class AddHechosRegistradosToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :hechos_registrados, :boolean
    add_index :causas, :hechos_registrados
  end
end
