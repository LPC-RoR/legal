class AddRegistroRevisadoToKrnDenunciado < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciados, :registro_revisado, :boolean
  end
end
