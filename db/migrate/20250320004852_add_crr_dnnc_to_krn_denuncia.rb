class AddCrrDnncToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :crr_dnnc, :boolean
  end
end
