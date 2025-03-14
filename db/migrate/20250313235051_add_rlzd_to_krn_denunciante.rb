class AddRlzdToKrnDenunciante < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciantes, :rlzd, :boolean
    remove_column :krn_denunciantes, :registro_revisado, :string
  end
end
