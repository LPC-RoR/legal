class AddPorentajeBaseToTarFormulaCuantia < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_formula_cuantias, :porcentaje_base, :decimal
  end
end
