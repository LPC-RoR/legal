class AddRepresentanteToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :representante, :string
    add_column :krn_denuncias, :documento_representacion, :string
  end
end
