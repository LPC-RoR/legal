class AddFechaUfToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :fecha_uf, :datetime
    add_index :causas, :fecha_uf
  end
end
