class AddNotaSeguimientoToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :nota_seguimiento, :text
  end
end
