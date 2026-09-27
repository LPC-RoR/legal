class AddSeguimientoProgramadoToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :seguimiento_programado_en, :datetime
    add_index  :leads, :seguimiento_programado_en
  end
end
