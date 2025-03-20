class AddObjetadoToKrnInvestigador < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_inv_denuncias, :objetado, :boolean
  end
end
