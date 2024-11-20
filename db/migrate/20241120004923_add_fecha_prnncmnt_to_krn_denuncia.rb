class AddFechaPrnncmntToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :fecha_prnncmnt, :datetime
  end
end
