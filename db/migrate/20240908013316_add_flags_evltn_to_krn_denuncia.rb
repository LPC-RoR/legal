class AddFlagsEvltnToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :leida, :boolean
    add_column :krn_denuncias, :incnsstnt, :boolean
    add_column :krn_denuncias, :incmplt, :boolean
  end
end
