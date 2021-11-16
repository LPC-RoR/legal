class AddEstadoToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :estado, :string
    add_index :causas, :estado
  end
end
