class AddDnncntOpcnEscritaToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :dnncnt_opcn_escrita, :boolean
  end
end
