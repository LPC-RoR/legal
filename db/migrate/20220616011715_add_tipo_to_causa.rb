class AddTipoToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :tipo, :string
    add_index :causas, :tipo
  end
end
