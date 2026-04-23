class AddKrnDenunciaIdToKrnTestigo < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_testigos, :krn_denuncia_id, :integer
    add_index :krn_testigos, :krn_denuncia_id
  end
end
