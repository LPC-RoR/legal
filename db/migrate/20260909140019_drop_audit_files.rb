class DropAuditFiles < ActiveRecord::Migration[8.0]
  def change
    drop_table :audit_notas
    drop_table :check_auditorias
    drop_table :control_documentos
  end
end
