class AddInvestigacionLocalToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :investigacion_local, :string
    add_index :krn_denuncias, :investigacion_local
  end
end
