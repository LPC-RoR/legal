class AddDiagnosticoFieldsToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :kind, :string, null: false, default: "presentacion"
    add_column :leads, :pregunta, :text
    add_column :leads, :respuestas, :jsonb, null: false, default: {}
    add_index :leads, :kind
  end
end
