class AddInvestigacionExternaToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :investigacion_externa, :boolean
  end
end
