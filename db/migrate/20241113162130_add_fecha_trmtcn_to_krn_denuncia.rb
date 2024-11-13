class AddFechaTrmtcnToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :fecha_trmtcn, :datetime
  end
end
