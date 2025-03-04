class AddProbabilidadToCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :causas, :probabilidad, :string
    add_column :causas, :potencial_perdida, :decimal
  end
end
