class AddFechaDvlcnToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :fecha_dvlcn, :datetime
  end
end
