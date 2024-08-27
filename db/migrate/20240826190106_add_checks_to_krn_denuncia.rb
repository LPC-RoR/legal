class AddChecksToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :presentado_por, :string
    add_column :krn_denuncias, :via_declaracion, :string
    add_column :krn_denuncias, :tipo_declaracion, :string
  end
end
