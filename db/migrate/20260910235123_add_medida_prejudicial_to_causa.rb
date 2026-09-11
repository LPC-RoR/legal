class AddMedidaPrejudicialToCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :causas, :medida_prejudicial, :boolean
    add_column :causas, :nulidad_despido, :boolean
  end
end
