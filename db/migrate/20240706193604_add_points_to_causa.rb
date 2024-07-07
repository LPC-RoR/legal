class AddPointsToCausa < ActiveRecord::Migration[7.1]
  def change
    add_column :causas, :pendiente, :boolean
    add_column :causas, :urgente, :boolean
  end
end
