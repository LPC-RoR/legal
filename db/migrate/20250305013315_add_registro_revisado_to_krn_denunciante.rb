class AddRegistroRevisadoToKrnDenunciante < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciantes, :registro_revisado, :boolean
  end
end
