class RemoveFieldsFromKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    remove_column :krn_denuncias, :fecha_ntfccn_invstgdr, :boolean
    remove_column :krn_denuncias, :fecha_prcsd, :datetime
  end
end
