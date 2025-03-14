class AddRlzdToKrnDenunciado < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciados, :rlzd, :boolean
    remove_column :krn_denunciados, :registro_revisado, :string
  end
end
