class AddSinCuantiaToCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :causas, :sin_cuantia, :boolean
    add_index :causas, :sin_cuantia
  end
end
