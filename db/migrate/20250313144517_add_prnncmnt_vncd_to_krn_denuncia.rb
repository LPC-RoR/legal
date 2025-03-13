class AddPrnncmntVncdToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :prnncmnt_vncd, :boolean
  end
end
