class AddEvlcnToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :evlcn_incmplt, :boolean
    add_column :krn_denuncias, :evlcn_incnsstnt, :boolean
    add_column :krn_denuncias, :evlcn_ok, :boolean
  end
end
