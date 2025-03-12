class AddPlzPrnncmntVncdToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :plz_prnncmnt_vncd, :datetime
  end
end
