class AddReceptorDenunciaToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :receptor_denuncia, :string
    add_index :krn_denuncias, :receptor_denuncia
  end
end
