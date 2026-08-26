class AddPrnncmntToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :prnncmnt, :string
  end
end
