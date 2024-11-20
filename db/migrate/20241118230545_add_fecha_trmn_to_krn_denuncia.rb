class AddFechaTrmnToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :fecha_trmn, :datetime
  end
end
