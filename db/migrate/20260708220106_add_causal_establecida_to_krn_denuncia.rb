class AddCausalEstablecidaToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :causal_establecida, :boolean
    add_index :krn_denuncias, :causal_establecida
  end
end
