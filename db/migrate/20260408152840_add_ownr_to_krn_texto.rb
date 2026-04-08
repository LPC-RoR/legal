class AddOwnrToKrnTexto < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_textos, :ownr_type, :string
    add_index :krn_textos, :ownr_type
    add_column :krn_textos, :ownr_id, :integer
    add_index :krn_textos, :ownr_id
    remove_column :krn_textos, :krn_denuncia_id, :integer
  end
end
