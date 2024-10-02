class AddMotivoDenunciaToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :motivo_denuncia, :string
    add_index :krn_denuncias, :motivo_denuncia
  end
end
