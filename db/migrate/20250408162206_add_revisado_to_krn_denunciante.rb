class AddRevisadoToKrnDenunciante < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciantes, :rvsd, :boolean
    add_column :krn_denunciados, :rvsd, :boolean
    add_column :krn_testigos, :rvsd, :boolean
  end
end
