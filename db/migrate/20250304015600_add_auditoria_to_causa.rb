class AddAuditoriaToCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :causas, :resultado, :text
    add_column :causas, :estimacion, :text
  end
end
