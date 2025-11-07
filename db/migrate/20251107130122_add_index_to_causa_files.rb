class AddIndexToCausaFiles < ActiveRecord::Migration[8.0]
  def change
    add_index :estados, [:causa_id, :fecha, :id], name: 'idx_estados_causa_fecha_id'
    
    # ▶️ Quita el WHERE de fecha
    add_index :age_actividades, [:ownr_type, :ownr_id, :fecha], name: 'idx_age_actividades_polymorphic_fecha'
    
    add_index :tar_valor_cuantias, [:ownr_type, :ownr_id], name: 'idx_tar_valor_cuantias_polymorphic'
    
    # ▶️ El WHERE en tipo SÍ es válido (es constante)
    add_index :monto_conciliaciones, [:causa_id, :fecha, :id], 
              where: "tipo IN ('Acuerdo', 'Sentencia')", 
              name: 'idx_montos_conc_causa_fecha_id_tipo'
    
    add_index :act_archivos, [:ownr_type, :ownr_id, :act_archivo], name: 'idx_act_archivos_polymorphic_tipo'
    add_index :active_storage_attachments, [:record_type, :record_id, :name], name: 'idx_as_attachments_record_name'
  end
end