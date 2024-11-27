class AddFechaNtfccnToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :fecha_ntfccn, :datetime
  end
end
