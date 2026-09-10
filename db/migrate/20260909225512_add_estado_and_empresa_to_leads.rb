class AddEstadoAndEmpresaToLeads < ActiveRecord::Migration[8.0]
  def change
    add_reference :leads, :empresa, null: false, foreign_key: true
  end
end
