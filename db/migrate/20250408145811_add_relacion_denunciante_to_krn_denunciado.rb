class AddRelacionDenuncianteToKrnDenunciado < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciados, :relacion_denunciante, :string
  end
end
