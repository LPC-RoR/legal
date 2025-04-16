class AddFechaCierreToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :fecha_cierre, :datetime
  end
end
